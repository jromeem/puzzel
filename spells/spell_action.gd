class_name SpellAction extends Node2D

signal spell_completed
signal effect_applied

var caster: Dino
var targets: Array
var spell_type: int
var damage: float
var duration: float

@onready var sprite: SpellAnimation

enum SpellType {ATTACK, DEBUFF, HEAL, BUFF, STATUS, ENVIRON}

func _init(spell_caster: Dino, spell_targets: Array):
	caster = spell_caster
	targets = spell_targets
	# Set initial position to caster's position
	position = spell_caster.position
	print("SpellAction initialized at position: ", position)

func _ready() -> void:
	# Find and setup sprite
	sprite = find_child("SpellAnimation")
	if sprite:
		sprite.spell_animation_started.connect(_on_animation_started)
		sprite.spell_animation_finished.connect(_on_animation_finished)
	
	# Call implementation specific setup
	_setup_spell()

func cast() -> void:
	if sprite:
		# Get target position relative to spell's position
		var target_pos = targets[0].position if targets.size() > 0 else position
		print("Casting from ", position, " to ", target_pos)
		
		# Connect to travel completion
		if !sprite.travel_completed.is_connected(_on_travel_completed):
			sprite.travel_completed.connect(_on_travel_completed)
		
		# Start travel phase from local position (0,0) to target position relative to spell
		var relative_target = target_pos - position
		sprite.start_travel(Vector2.ZERO, relative_target)
	else:
		print("No sprite found!")
		_apply_effects()
		emit_signal("spell_completed")
		#queue_free()

func _on_travel_completed() -> void:
	print('here yet?')
	#queue_free()
	# Travel is done, start the effect animation
	sprite.start_animation()

func _on_animation_started() -> void:
	_apply_effects()

func _on_animation_finished() -> void:
	emit_signal("spell_completed")
	#queue_free()

# Virtual method for spell-specific setup
func _setup_spell() -> void:
	pass

# Virtual method for spell-specific effects
func _apply_effects() -> void:
	pass
