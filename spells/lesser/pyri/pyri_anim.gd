# pyri_anim.gd
extends SpellAnimation

var loop_count = 0
const MAX_LOOPS = 3

func _ready() -> void:
	print("PyriAnimation ready")

func _on_animation_finished() -> void:
	if is_traveling:
		return  # Don't process animation sequences during travel
		
	print("PyriAnim finished:", animation, " Loop count:", loop_count)
	
	match animation:
		"start":
			print("Start finished, playing loop")
			loop_count = 0
			play("loop")
		"loop":
			loop_count += 1
			if loop_count >= MAX_LOOPS:
				print("Max loops reached, playing end")
				play("end")
			else:
				print("Continuing loop")
				play("loop")
		"end":
			print("End finished, emitting completion")
			spell_animation_finished.emit()
