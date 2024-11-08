class_name Main extends Node2D

enum State { IDLE, WALKING_LEFT, WALKING_RIGHT, CONJURING, CASTING }
enum Tile { LEFT = 0, MIDDLE = 1, RIGHT = 2 }
enum Direction { LEFT = -1, RIGHT = 1 }

var current_state: State = State.IDLE
var current_tile: Tile = Tile.MIDDLE
var movement_tween: Tween = null
var is_moving: bool = false

@onready var dino: CharacterBody2D = $Dino
@onready var dino_sprite: AnimatedSprite2D = $Dino/AnimatedSprite

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
	# If we can't move in the requested direction, immediately return to idle
	if not can_move(direction):
		transition_to(State.IDLE)
		return
		
	# Don't start a new movement if one is in progress
	if is_moving:
		return
		
	is_moving = true
	var target_tile = MOVEMENT_CONSTRAINTS[current_tile][direction]
	
	dino_sprite.play('walk')
	dino_sprite.flip_h = (direction == Direction.LEFT)
	
	movement_tween = create_tween()
	movement_tween.tween_property(dino, "position", TILE_POSITIONS[target_tile], 0.3)
	
	await movement_tween.finished
	current_tile = target_tile
	is_moving = false
	
	# After movement completes, check current input state
	if Input.is_action_pressed("left") and can_move(Direction.LEFT):
		walk(Direction.LEFT)
	elif Input.is_action_pressed("right") and can_move(Direction.RIGHT):
		walk(Direction.RIGHT)
	else:
		transition_to(State.IDLE)

func handle_movement_input() -> void:
	# Only handle movement input if we're not already moving
	if is_moving:
		return
		
	if Input.is_action_pressed("left"):
		# Only transition to walking state if movement is possible
		if can_move(Direction.LEFT):
			transition_to(State.WALKING_LEFT)
		else:
			transition_to(State.IDLE)
	elif Input.is_action_pressed("right"):
		if can_move(Direction.RIGHT):
			transition_to(State.WALKING_RIGHT)
		else:
			transition_to(State.IDLE)

func handle_state() -> void:
	match current_state:
		State.IDLE:
			handle_idle()
		State.WALKING_LEFT:
			walk(Direction.LEFT)
		State.WALKING_RIGHT:
			walk(Direction.RIGHT)
		State.CONJURING:
			handle_conjuring()
		State.CASTING:
			handle_casting()

func handle_idle() -> void:
	dino_sprite.flip_h = false
	dino_sprite.play("idle")

func handle_conjuring() -> void:
	pass

func handle_casting() -> void:
	pass

func transition_to(new_state: State) -> void:
	current_state = new_state

func _physics_process(_delta: float) -> void:
	# Always check for input, but handle it based on current state
	if current_state == State.IDLE or current_state == State.WALKING_LEFT or current_state == State.WALKING_RIGHT:
		handle_movement_input()
	handle_state()
