# pyri.gd
class_name Pyri extends SpellAction

const PYRI_DAMAGE = 25.0
const PYRI_DURATION = 1.0
const PYRI_SCENE = preload("res://spells/lesser/pyri/pyri.tscn")

func _init(spell_caster: CharacterBody2D, spell_targets: Array):
	super._init(spell_caster, spell_targets)

func _ready() -> void:
	super._ready()
	print("Pyri position at ready: ", position)
	
	var spell_instance = PYRI_SCENE.instantiate()
	add_child(spell_instance)
	
	for child in spell_instance.get_children():
		if child is SpellAnimation:
			sprite = child
			sprite.show()  # Make sure sprite is visible
			sprite.spell_animation_started.connect(_on_animation_started)
			sprite.spell_animation_finished.connect(_on_animation_finished)
			print("Found and setup SpellAnimation at position: ", sprite.position)
			break
	
	spell_type = SpellType.ATTACK
	damage = PYRI_DAMAGE
	duration = PYRI_DURATION

func _process(_delta: float) -> void:
	if sprite and sprite.is_traveling:
		print("Spell current position: ", global_position, " Sprite position: ", sprite.global_position)

func _apply_effects() -> void:
	for target in targets:
		if target.has_method("take_damage"):
			target.take_damage(damage)
	emit_signal("effect_applied")
