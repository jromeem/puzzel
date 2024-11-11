extends Node

@onready var dino: Dino = $"../Dino"
@onready var slime: CharacterBody2D = $"../Slime"
@onready var ui: UI = $"../UI"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	ui.connect("spell_ready", on_spell_ready)

func on_spell_ready(spell_components):
	print(spell_components) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
