class_name SpellAnimation
extends AnimatedSprite2D

signal spell_animation_started
signal spell_animation_finished

func _ready() -> void:
	# Connect to our own animation_finished signal
	animation_finished.connect(_on_animation_finished)

func start_animation() -> void:
	play("start")
	spell_animation_started.emit()

# Virtual method to be overridden
func _on_animation_finished() -> void:
	pass
