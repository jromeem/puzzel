class_name IdleState extends State

@export var dino: Dino

func Enter():
	dino.idles()

func Update(_delta: float):
	if Input.is_action_pressed("left") and dino.can_move(Dino.Direction.LEFT):
		Transitioned.emit(self, "walking_left")
	elif Input.is_action_pressed("right") and dino.can_move(Dino.Direction.RIGHT):
		Transitioned.emit(self, "walking_right")
	
	if Input.is_action_just_pressed("conjure"):
		Transitioned.emit(self, "conjuring")
