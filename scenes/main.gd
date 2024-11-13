class_name Main extends Node2D

@onready var level: Level = $Level
@onready var player_tiles: Area2D = $"Level/Player Tiles"
@onready var enemy_tiles: Area2D = $"Level/Enemy Tiles"
@onready var dino: Dino = $Dino
@onready var slime: CharacterBody2D = $Slime

var player_tile_pos
var enemy_tile_pos

# Additional methods for game flow coordination
func start_game() -> void:
	# Initialize game state
	pass

func pause_game() -> void:
	# Pause game systems
	pass

func resume_game() -> void:
	# Resume game systems
	pass

func game_over() -> void:
	# Handle game over state
	pass

func _ready() -> void:
	player_tile_pos = level.populate_positions(
		level.player_tiles,
		dino.position.y,
		level.player_tiles.global_position)
		
	enemy_tile_pos = level.populate_positions(
		level.enemy_tiles,
		slime.position.y,
		level.enemy_tiles.global_position)
		
	print(player_tile_pos, enemy_tile_pos)
