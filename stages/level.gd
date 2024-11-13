class_name Level extends Node2D

@onready var enemy_tiles: Area2D = $"Enemy Tiles"
@onready var player_tiles: Area2D = $"Player Tiles"

func populate_positions(tiles_set):
	var pos_dict = {}
	var tiles = tiles_set.get_children()
	var index = 0
	for t in tiles:
		if t is Area2D:
			pos_dict[index] = floor(t.position)
			index += 1
	return pos_dict
