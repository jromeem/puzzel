class_name Pyri2 extends Area2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
const PYRI_SCENE = preload("res://spells/lesser/pyri/pyri2.tscn")

func shot():
	animation_player.play("shot")
	
func loop():
	animation_player.play("loop")
