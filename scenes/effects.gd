# effects.gd
extends Node

@onready var dino: Dino = $"../Dino"
@onready var slime: Area2D = $"../Slime"
@onready var ui: UI = $"../UI"
@onready var level: Level = $"../Level"
var enemy_tiles: Dictionary

var spell_registry = {
	"pyri": Pyri2,
}

func _ready() -> void:
	ui.connect("spell_ready", _on_spell_ready)
	enemy_tiles = level.populate_positions(
		level.enemy_tiles,
		slime.position.y,
		level.enemy_tiles.global_position)

func summon_spell(spell_name):
	var spellclass = spell_registry[spell_name]
	var spell_instance: Pyri2 = spellclass.new()
	var instance = spell_instance.PYRI_SCENE.instantiate()
	var instance2 = spell_instance.PYRI_SCENE.instantiate()
	var current_tile = dino.current_tile
	print("current_ti", current_tile)
	var target = enemy_tiles.get(str(current_tile as int + 1)) - Vector2(140, 0) # offset by 140px to the left
	
	add_child(instance)
	instance.position = dino.position
	
	# Start shot animation and movement
	instance.shot()
	var tween = create_tween()
	tween.tween_property(instance, "position", target, 0.4)
	
	# When movement completes, switch to loop animation
	await tween.finished
	instance.animation_player.play("RESET")
	instance.queue_free()
	
	add_child(instance2)
	instance2.animation_player.play("RESET")
	instance2.position = target
	instance2.loop()
	
	tween = create_tween()
	tween.tween_property(instance2, "position", target, 1)
	await tween.finished
	instance2.queue_free()
	
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
