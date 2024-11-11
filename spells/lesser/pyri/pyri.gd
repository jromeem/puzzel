# pyri.gd
class_name Pyri extends SpellAction

const PYRI_DAMAGE := 25.0
const PYRI_DURATION := 1.0
const PYRI_SCENE := preload("res://spells/lesser/pyri/pyri.tscn")

func _init(spell_caster: CharacterBody2D, spell_targets: Array[Node2D]):
	super._init(spell_caster, spell_targets)

func _ready() -> void:
	var spell_instance = PYRI_SCENE.instantiate()
	add_child(spell_instance)
	
	# Look for direct children first
	for child in spell_instance.get_children():
		if child is SpellAnimation:
			sprite = child
			break
	
	if sprite:
		sprite.spell_animation_started.connect(_on_animation_started)
		sprite.spell_animation_finished.connect(_on_animation_finished)
	else:
		pass
	
	spell_type = SpellType.ATTACK
	damage = PYRI_DAMAGE
	duration = PYRI_DURATION

func _apply_effects() -> void:
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage)
	emit_signal("effect_applied")
