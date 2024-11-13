class_name Character extends Node

@export var sprite: CharacterBody2D # prob abstract this into its own class to deal with states and animation changes

# all dictionarys here are dictionaries of objets (?? maybe) (maybe lists would be better)

var max_health: int
var health: float
var mana: float
var base_stats: Dictionary # haha todo
var armor: Dictionary      # also todo 

# temporary status effects
var status_effects: Array # list of current status effects (objs?), empty list is no status effects

signal health_low
signal health_depleted

#signal mana_low
#signal mana_depleted

func _ready() -> void:
	health_low.connect(_on_health_low)
	health_low.connect(_on_health_depleted)
	
func _process(_delta: float):
	if health <= 0:
		health_depleted.emit()
		
	if health < (max_health * 0.20):
		health_low.emit()
	
func _on_health_depleted():
	print('health is depleted!')	

func _on_health_low():
	print('health is low!')
