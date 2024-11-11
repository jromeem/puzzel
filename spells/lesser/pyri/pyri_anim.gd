extends AnimatedSprite2D

var loop = 0
var MAX_LOOPS = 3

@onready var sprite: AnimatedSprite2D = $"."

func cast():
	sprite.play("start")

# for starting animation, looping an animation, then finishing animation
func _on_animation_finished():
	var anim = sprite.animation
	match (anim):
		"start":
			if (sprite.animation_finished):
				sprite.play("loop")
		"loop":
			if (sprite.animation_finished):
				loop += 1
				sprite.play("loop")
			if (loop > MAX_LOOPS):
				sprite.play("end")
		"end":
			if (sprite.animation_finished):
				queue_free()
