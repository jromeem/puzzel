extends Area2D

@onready var area: Area2D = $"."
@onready var character: Character = $Character
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite
@onready var health_bar: HealthBar = $HealthBar

var health = Health.new()

# register components here
func _ready() -> void:
	health.set_health(41)
	health_bar.set_health(health)
	health.connect("health_zero", _on_health_zero)

# complex spell calculation takes place here
func _on_area_entered(area: Area2D) -> void:
	if (area is Pyri2):
		var pyri_spell: Pyri2 = area
		take_damage(-10.0)
	
# complex stats resolving takes place here
func take_damage(amount: float):
	health.changed(amount)
	animated_sprite.play("hit")
	
# death animation and queue_free() from scene tree
func _on_health_zero():
	print('slime dead!!')
	queue_free()
	# queue free messing up other animations
	
