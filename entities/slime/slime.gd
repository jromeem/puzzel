extends Area2D

@onready var area: Area2D = $"."
@onready var character: Character = $Character
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite

func _ready() -> void:
	pass
	
func _process(delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	print('entered my body!!!!! ', body)
