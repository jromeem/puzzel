class_name CastingState extends State

@export var dino: CharacterBody2D

func Enter():
	print('are you casting?')

func Update(_delta: float):
	if Input.is_action_just_pressed("conjure_end"):
		Transitioned.emit(self, "idle")
