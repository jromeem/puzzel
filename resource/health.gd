class_name Health
extends Resource

var value: float = 0
var low_percentage: float = 0.20

signal health_low
signal health_zero
signal health_just_changed(amount)

func set_health(val: float):
	value = val

func changed(amount: float):
	value += amount
	if value <= 0:
		value = 0
		health_zero.emit()
	health_just_changed.emit(amount)
