extends Node

@onready var dino: Dino = $"../Dino"
@onready var slime: CharacterBody2D = $"../Slime"
@onready var ui: UI = $"../UI"

var active_spells: Array[SpellAction] = []

func _ready() -> void:
	ui.connect("spell_ready", _on_spell_ready)

func _on_spell_ready(spell_components: Dictionary) -> void:
	var spell_action: SpellAction
	
	match spell_components["root"]:
		"pyri":
			print('Creating Pyri spell')
			spell_action = Pyri.new(dino, [slime])
			print('Adding Pyri to scene tree')
			add_child(spell_action)
			spell_action.connect("spell_completed", _on_spell_completed.bind(spell_action))
			active_spells.append(spell_action)
			print('Casting Pyri')
			spell_action.cast()
		# Add more spells here
		_:
			print("Unknown spell: ", spell_components["root"])

func _on_spell_completed(spell: SpellAction) -> void:
	active_spells.erase(spell)
