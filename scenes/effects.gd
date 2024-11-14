# effects.gd
extends Node

@onready var dino: Dino = $"../Dino"
@onready var slime: Area2D = $"../Slime"
@onready var ui: UI = $"../UI"

var spell_registry = {
	"pyri": Pyri2,
}

func _ready() -> void:
	ui.connect("spell_ready", _on_spell_ready)

func summon_spell(spell_name):
	var spellclass = spell_registry[spell_name]
	var spell: Pyri2 = spellclass.new()
	var instance = spell.PYRI_SCENE.instantiate()
	spell.position = dino.position
	add_child(instance)
	instance.rotate(3 * PI/2)
	instance.shot()
	var movement_tween = create_tween()
	movement_tween.tween_property(instance, "position", slime.position, 1)
	movement_tween.tween_callback(do_that.bind(instance))
	
func do_that(instance: Pyri2):
	instance.loop()
	instance.scale = Vector2(3, 3)
	instance.rotate(PI/2)
	var movement_tween = create_tween()
	movement_tween.tween_property(instance, "position", slime.position, 1)
	movement_tween.tween_callback(go_away.bind(instance))
	
func go_away(instance):
	instance.queue_free()
	
func _on_spell_ready(spell_components: Dictionary) -> void:
	var spell_name = spell_components["root"]
	if spell_name in spell_registry:
		summon_spell(spell_name)
	else:
		push_warning("Unknown spell: %s" % spell_name)

func _on_spell_completed(spell: SpellAction) -> void:
	print('_on_spell_completed')
	# Cleanup happens automatically through queue_free()
	pass
