class_name ConjuringState extends State

@export var dino: Dino

func Enter():
	dino.conjures()
	dino.conjuring_start.emit()

func Exit():
	dino.conjuring_end.emit()

func Update(_delta: float):
	if Input.is_action_just_pressed("conjure_end"):
		Transitioned.emit(self, "idle")
