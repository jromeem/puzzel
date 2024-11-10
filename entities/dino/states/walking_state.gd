# walking_state.gd
# walking_state.gd
class_name WalkingState extends State

@export var dino: Dino
@export_enum("Left:-1", "Right:1") var direction: int = 1  # Default to right

func Enter():
	dino.is_moving = true
	dino.walks(direction == -1)  # -1 is left
	walk()

func walk() -> void:
	# Convert int to Direction enum value
	var dir = direction as Dino.Direction
	
	if not dino.can_move(dir):
		Transitioned.emit(self, "idle")
		return
		
	var current_tile_str = str(dino.current_tile as int)
	var dir_str = str(dir as int)
	
	var constraints = dino.MOVEMENT_CONSTRAINTS.get(current_tile_str)
	
	var target_tile_str = constraints.get(dir_str)
	
	if target_tile_str == null:
		return
	
	var target_position = dino.get_target_position(target_tile_str)
	
	dino.movement_tween = dino.create_tween()
	dino.movement_tween.tween_property(dino, "position", target_position, 0.3)
	dino.movement_tween.finished.connect(_on_movement_finished.bind(target_tile_str.to_int() as Dino.Tile))

func _on_movement_finished(target_tile: Dino.Tile) -> void:
	dino.current_tile = target_tile
	dino.is_moving = false
	
	if dino.conjure_queued:
		dino.conjure_queued = false
		Transitioned.emit(self, "conjuring")
		return
		
	if Input.is_action_pressed("left") and dino.can_move(Dino.Direction.LEFT):
		walk()
	elif Input.is_action_pressed("right") and dino.can_move(Dino.Direction.RIGHT):
		walk()
	else:
		Transitioned.emit(self, "idle")

func Update(_delta: float):
	if Input.is_action_just_pressed("conjure"):
		dino.conjure_queued = true
