class_name Pyri2 extends Area2D

enum SpellState { SHOT, LOOP, FINISHED }
var current_state = SpellState.SHOT
const PYRI_SCENE = preload("res://spells/lesser/pyri/pyri2.tscn")

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func shot():
	animation_player.play("shot")
	
func loop():
	animation_player.play("loop")

func _process(delta):
	match current_state:
		SpellState.SHOT:
			if not animation_player.is_playing():
				current_state = SpellState.LOOP
				loop()
		SpellState.LOOP:
			pass
