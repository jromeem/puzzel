class_name PlayerTile extends Area2D

@onready var tile_0: Area2D = $Tile0
@onready var tile_1: Area2D = $Tile1
@onready var tile_2: Area2D = $Tile2

func _on_tile0_body_entered(body: Node2D) -> void:
	#print('entering tile0', body)
	pass

func _on_tile1_body_entered(body: Node2D) -> void:
	#print('entering tile1')
	pass

func _on_tile2_body_entered(body: Node2D) -> void:
	#print('entering tile2')
	pass
