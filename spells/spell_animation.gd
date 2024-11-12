# spell_animation.gd
class_name SpellAnimation
extends AnimatedSprite2D

signal spell_animation_started
signal spell_animation_finished
signal travel_completed

var is_traveling = false
var start_position: Vector2
var target_position: Vector2
var travel_speed = 400.0

func _on_animation_finished():
	pass
	
func start_animation():
	print('here yet2? ')
	play('start')

func _ready() -> void:
	if !animation_finished.is_connected(_on_animation_finished):
		animation_finished.connect(_on_animation_finished)
	print("SpellAnimation base class ready")
	# Make sure sprite is visible
	show()

func start_travel(from_pos: Vector2, to_pos: Vector2) -> void:
	start_position = from_pos
	target_position = to_pos
	position = start_position
	is_traveling = true
	# Make sure we're visible
	show()
	play("shot")
	print("Starting travel from ", from_pos, " to ", to_pos)

func _process(delta: float) -> void:
	if is_traveling:
		var direction = (target_position - position).normalized()
		var distance = position.distance_to(target_position)
		var move_distance = travel_speed * delta
		
		print("Current pos: ", position, " Target: ", target_position, " Distance: ", distance)
		
		if distance <= move_distance:
			# Reached the target
			position = target_position
			is_traveling = false
			print("Travel completed!")
			travel_completed.emit()
		else:
			position += direction * move_distance
