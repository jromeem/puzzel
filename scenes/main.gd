class_name Main extends Node2D

# game states
enum PlayerState { IDLE, WALKING_LEFT, WALKING_RIGHT, CONJURING, CASTING }
enum UIState { SPELLING }
enum Tile { LEFT = 0, MIDDLE = 1, RIGHT = 2 }
enum Direction { LEFT = -1, RIGHT = 1 }

# signals
signal conjuring_start
signal conjuring_end

# game initial values
var current_state: PlayerState = PlayerState.IDLE
var previous_state: PlayerState = PlayerState.IDLE
var current_tile: Tile = Tile.MIDDLE
var movement_tween: Tween = null
var is_moving: bool = false
var conjure_queued: bool = false

@onready var dino: Dino = $Dino
@onready var dino_sprite: AnimatedSprite2D = $Dino/DinoSprite
@onready var ui: Control = $UI

const TILE_POSITIONS = {
	Tile.LEFT: Vector2(-615, 560),    # tile 0
	Tile.MIDDLE: Vector2(-430, 600),  # tile 1
	Tile.RIGHT: Vector2(-240, 640)    # tile 2
}

const MOVEMENT_CONSTRAINTS = {
	Tile.LEFT: { Direction.LEFT: null, Direction.RIGHT: Tile.MIDDLE },
	Tile.MIDDLE: { Direction.LEFT: Tile.LEFT, Direction.RIGHT: Tile.RIGHT },
	Tile.RIGHT: { Direction.LEFT: Tile.MIDDLE, Direction.RIGHT: null }
}

func can_move(direction: Direction) -> bool:
	return MOVEMENT_CONSTRAINTS[current_tile][direction] != null

func walk(direction: Direction) -> void:
	if not can_move(direction):
		handle_movement_end()
		return
		
	if is_moving:
		return
		
	is_moving = true
	var target_tile = MOVEMENT_CONSTRAINTS[current_tile][direction]

	dino.walks(direction == Direction.LEFT)
	
	movement_tween = create_tween()
	movement_tween.tween_property(dino, "position", TILE_POSITIONS[target_tile], 0.3)
	
	await movement_tween.finished
	current_tile = target_tile
	is_moving = false
	
	# Check if conjuring was requested during movement
	if conjure_queued:
		handle_movement_end()
		return
		
	# Continue walking if direction is still held
	if Input.is_action_pressed("left") and can_move(Direction.LEFT):
		walk(Direction.LEFT)
	elif Input.is_action_pressed("right") and can_move(Direction.RIGHT):
		walk(Direction.RIGHT)
	else:
		handle_movement_end()

func handle_movement_end() -> void:
	is_moving = false
	if conjure_queued:
		conjure_queued = false
		transition_to(PlayerState.CONJURING)
	else:
		transition_to(PlayerState.IDLE)

func handle_movement_input() -> void:
	if is_moving:
		return
		
	if Input.is_action_pressed("left"):
		if can_move(Direction.LEFT):
			transition_to(PlayerState.WALKING_LEFT)
		else:
			handle_movement_end()
	elif Input.is_action_pressed("right"):
		if can_move(Direction.RIGHT):
			transition_to(PlayerState.WALKING_RIGHT)
		else:
			handle_movement_end()

func handle_state() -> void:
	match current_state:
		PlayerState.IDLE:
			handle_idle()
		PlayerState.WALKING_LEFT:
			walk(Direction.LEFT)
		PlayerState.WALKING_RIGHT:
			walk(Direction.RIGHT)
		PlayerState.CONJURING:
			handle_conjuring()
		PlayerState.CASTING:
			handle_casting()

func handle_idle() -> void:
	dino.idles()

func handle_conjuring() -> void:
	dino.conjures()
	
	if Input.is_action_just_pressed("conjure_end"):
		transition_to(PlayerState.IDLE)
		conjuring_end.emit()
		ui.toggle_ui()

func handle_casting() -> void:
	pass

func transition_to(new_state: PlayerState) -> void:
	previous_state = current_state
	current_state = new_state
	
	# Only emit conjuring_start when first entering conjuring state
	if current_state == PlayerState.CONJURING and previous_state != PlayerState.CONJURING:
		conjuring_start.emit()
		ui.toggle_ui()

func check_conjure_input() -> void:
	if Input.is_action_just_pressed("conjure"):
		if is_moving:
			# Queue conjuring to start after movement completes
			conjure_queued = true
		else:
			# Start conjuring immediately if not moving
			transition_to(PlayerState.CONJURING)

func _physics_process(_delta: float) -> void:
	if current_state == PlayerState.IDLE or current_state == PlayerState.WALKING_LEFT or current_state == PlayerState.WALKING_RIGHT:
		handle_movement_input()
	
	# Check for conjuring input in any state except CONJURING
	if current_state != PlayerState.CONJURING:
		check_conjure_input()
	
	handle_state()

func _on_conjuring_start() -> void:
	print('conjuring start signal')
	pass # Replace with function body.

func _on_conjuring_end() -> void:
	print('conjuring end signal')
	pass # Replace with function body.
