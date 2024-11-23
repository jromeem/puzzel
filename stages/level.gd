class_name Level extends Node2D

@onready var enemy_tiles: EnemyTiles = $"Enemy Tiles"
@onready var player_tiles: Area2D = $"Player Tiles"

func _ready() -> void:
	print(position)
	print(global_position)

# find the tile positions for the player given all the scene transformations
func populate_positions(tiles_set, player_pos_y = 0, global_pos = Vector2(0, 0)):
	var pos_dict = {}
	var tiles = tiles_set.get_children()
	var index = 0
	for t in tiles:
		if t is Area2D:
			var base_pos = floor(t.position * player_tiles.scale * global_scale)
			var adjusted_x = 1 + (140 * (index - 1))   # Centers around x=1 with 140 unit spacing
			pos_dict[str(index)] = Vector2(adjusted_x + global_pos.x, player_pos_y)  # Uses dino's y position
			index += 1
	return pos_dict
