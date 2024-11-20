class_name Dino extends Area2D

# a lot of logic here that needs to be separated!!

signal conjuring_start
signal conjuring_end

@export var ui: UI
@export var level: Level

@onready var slime: Area2D = $"../Slime" # maybe needs to be somewhere else?
@onready var dino_sprite: AnimatedSprite2D = $DinoSprite
@onready var conjuring_fx: AnimatedSprite2D = $ConjuringFX
@onready var state_machine: StateMachine = $StateMachine

@onready var character: Character = $Character # the soul
@onready var health_bar: Control = $HealthBar

var health = Health.new()

var local_signals: Array

enum Tile { LEFT = 0, MIDDLE = 1, RIGHT = 2 }
enum Direction { LEFT = -1, RIGHT = 1 }

var current_tile: Tile = Tile.MIDDLE
var movement_tween: Tween = null
var is_moving: bool = false
var conjure_queued: bool = false
var TILE_POSITIONS

const MOVEMENT_CONSTRAINTS = {
	"0": { "-1": null, "1": "1" },     # LEFT tile: can't go left, can go right to MIDDLE
	"1": { "-1": "0", "1": "2" },      # MIDDLE tile: can go left to LEFT, right to RIGHT
	"2": { "-1": "1", "1": null }      # RIGHT tile: can go left to MIDDLE, can't go right
}

func _ready() -> void:
	# register visual components with data resource class
	# healthbar with the instantiated health object
	health.set_health(100)
	health_bar.set_health(health)
	
	# movement component ? tiles component
	# tiles component with the instantianted move object??
	
	TILE_POSITIONS = level.populate_positions(
		level.player_tiles,
		position.y,
		level.player_tiles.global_position)
	conjuring_fx.visible = false
	local_signals.append(health.signals)
	
func take_damage(amount: float):
	health.changed(amount)

func can_move(direction: Direction) -> bool:
	var tile_str = str(current_tile as int)
	var dir_str = str(direction as int)
	
	var constraints = MOVEMENT_CONSTRAINTS.get(tile_str)
	
	if constraints == null:
		return false
		
	var can_move_val = constraints.get(dir_str) != null
	return can_move_val

func get_target_position(target_tile_str: String) -> Vector2:
	return TILE_POSITIONS.get(target_tile_str, Vector2.ZERO)

func idles(flipped = false) -> void:
	dino_sprite.play("idle")
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = false    

func walks(flipped = false) -> void:
	dino_sprite.play('walk')
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = false

func conjures(flipped = false) -> void:
	dino_sprite.play("step")
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = true

func _on_conjuring_end() -> void:
	ui.toggle_ui()

func _on_conjuring_start() -> void:
	ui.toggle_ui()

func _on_tree_entered() -> void:
	pass # Replace with function body.

func _on_tree_exited() -> void:
	pass # Replace with function body.
