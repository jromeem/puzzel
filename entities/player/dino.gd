class_name Dino extends CharacterBody2D

signal conjuring_start
signal conjuring_end

@onready var dino_sprite: AnimatedSprite2D = $DinoSprite
@onready var conjuring_fx: AnimatedSprite2D = $ConjuringFX
@onready var state_machine: StateMachine = $StateMachine

enum Tile { LEFT = 0, MIDDLE = 1, RIGHT = 2 }
enum Direction { LEFT = -1, RIGHT = 1 }

var current_tile: Tile = Tile.MIDDLE
var movement_tween: Tween = null
var is_moving: bool = false
var conjure_queued: bool = false

const TILE_POSITIONS = {
	"0": Vector2(-615, 560),    # Tile.LEFT
	"1": Vector2(-430, 600),    # Tile.MIDDLE
	"2": Vector2(-240, 640)     # Tile.RIGHT
}

const MOVEMENT_CONSTRAINTS = {
	"0": { "-1": null, "1": "1" },     # LEFT tile: can't go left, can go right to MIDDLE
	"1": { "-1": "0", "1": "2" },      # MIDDLE tile: can go left to LEFT, right to RIGHT
	"2": { "-1": "1", "1": null }      # RIGHT tile: can go left to MIDDLE, can't go right
}

func _ready() -> void:
	conjuring_fx.visible = false

func can_move(direction: Direction) -> bool:
	var tile_str = str(current_tile as int)
	var dir_str = str(direction as int)
	
	var constraints = MOVEMENT_CONSTRAINTS.get(tile_str)
	
	if constraints == null:
		return false
		
	var can_move = constraints.get(dir_str) != null
	return can_move

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
