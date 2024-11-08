class_name Dino extends CharacterBody2D

@onready var dino_sprite: AnimatedSprite2D = $DinoSprite
@onready var conjuring_fx: AnimatedSprite2D = $ConjuringFX

func _ready() -> void:
	conjuring_fx.visible = false

func idles(flipped = false) -> void:
	dino_sprite.play("idle")
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = false	

func walks(flipped = false) -> void:
	dino_sprite.play('walk')
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = false

func conjures(flipped = false) -> void:
	dino_sprite.play("step")
	dino_sprite.flip_h = flipped
	conjuring_fx.visible = true
