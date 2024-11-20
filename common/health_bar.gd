class_name HealthBar
extends Control

var health: Health
var max_health: float

@onready var alive: Panel = $AliveContainer/Alive
@onready var alive_container: BoxContainer = $AliveContainer

@onready var dead: Panel = $DeadContainer/Dead
@onready var dead_container: BoxContainer = $DeadContainer

func set_health(h: Health):
	health = h
	max_health = h.value
	
	health.connect("health_just_changed", _on_health_just_changed)
	add_health_bars()

func add_health_bars():
	var panel_amount = health.value / 10
	for i in range(panel_amount - 1):
		var new_alive_panel = alive.duplicate(0)
		var new_dead_panel = dead.duplicate(0)
		alive_container.add_child(new_alive_panel)
		dead_container.add_child(new_dead_panel)
	
func _on_health_just_changed(amount: float):
	var panel_step = max_health / 10
	for i in range(panel_step):
		if (i * 10 < health.value):
			alive_container.get_child(i).z_index = 0
		else:
			alive_container.get_child(i).z_index = -1
