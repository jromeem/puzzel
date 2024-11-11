extends SpellAnimation

var loop_count := 0
const MAX_LOOPS := 3

func _ready() -> void:
	super._ready()  # Important: Call parent _ready to set up base signal connection

func _on_animation_finished() -> void:
	
	match animation:
		"start":
			play("loop")
		"loop":
			loop_count += 1
			if loop_count >= MAX_LOOPS:
				play("end")
			else:
				play("loop")
		"end":
			spell_animation_finished.emit()
		_:
			pass
