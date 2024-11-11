class_name SpellAction extends Node2D

signal spell_completed
signal effect_applied

var caster: CharacterBody2D
var targets: Array[Node2D]
var spell_type: int
var damage: float
var duration: float

@onready var sprite: SpellAnimation

enum SpellType {ATTACK, DEBUFF, HEAL, BUFF, STATUS, ENVIRON}

func _init(spell_caster: CharacterBody2D, spell_targets: Array[Node2D]):
	caster = spell_caster
	targets = spell_targets

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
		sprite.start_animation()
	else:
		print("No sprite found for cast!")
		_apply_effects()
		emit_signal("spell_completed")
		queue_free()

func _on_animation_started() -> void:
	_apply_effects()

func _on_animation_finished() -> void:
	emit_signal("spell_completed")
	queue_free()

# Virtual method for spell-specific setup
func _setup_spell() -> void:
	pass

# Virtual method for spell-specific effects
func _apply_effects() -> void:
	pass
