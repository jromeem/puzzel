# effects.gd
extends Node

@onready var dino: Dino = $"../Dino"
@onready var slime: Area2D = $"../Slime"
@onready var ui: UI = $"../UI"

var spell_registry = {
	"pyri": Pyri,
}

func _ready() -> void:
	ui.connect("spell_ready", _on_spell_ready)

func _on_spell_ready(spell_components: Dictionary) -> void:
	var spell_name = spell_components["root"]
	if spell_name in spell_registry:
		var SpellClass = spell_registry[spell_name]
		var spell = SpellClass.new(dino, [slime])
		add_child(spell)
		spell.connect("spell_completed", func(): _on_spell_completed(spell))
		spell.cast()
	else:
		push_warning("Unknown spell: %s" % spell_name)

func _on_spell_completed(spell: SpellAction) -> void:
	print('_on_spell_completed')
	# Cleanup happens automatically through queue_free()
	pass
