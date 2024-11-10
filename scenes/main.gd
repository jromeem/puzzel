class_name Main extends Node2D

@onready var dino: Dino = $Dino
@onready var ui2: UI2 = $UI2

func _ready() -> void:
	# Connect to dino's signals
	dino.conjuring_start.connect(_on_dino_conjuring_start)
	dino.conjuring_end.connect(_on_dino_conjuring_end)

func _on_dino_conjuring_start() -> void:
	print("Conjuring started")
	ui2.toggle_ui()
	# Add any game-wide effects or state changes needed when conjuring starts
	# For example:
	# - Pause other game systems
	# - Start particle effects
	# - Play sound effects
	pass

func _on_dino_conjuring_end() -> void:
	print("Conjuring ended")
	ui2.toggle_ui()
	# Add any game-wide effects or state changes needed when conjuring ends
	# For example:
	# - Resume other game systems
	# - Stop effects
	# - Update game state
	pass

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
