extends Node2D

var money_spawn_locs = []
var npc_spawn_locs = []

func _ready():
	randomize()
	var tilemap = get_node("Navigation2D/TileMap")
	var cells = tilemap.get_used_cells()
	for cell in cells:
		if tilemap.get_cellv(cell) == 0:
			money_spawn_locs.append(tilemap.map_to_world(cell)) 
		elif tilemap.get_cellv(cell) == 2:
			npc_spawn_locs.append(tilemap.map_to_world(cell))
	
	for i in range(npc_spawn_locs.size()):
		spawn_money()
		npc_spawn(i)
	
	pass

func money_collected():
	spawn_money()
	npc_spawn(-1)

func spawn_money():
	var money = preload("res://money.tscn").instance()
	money.set_pos(get_random_floor_loc())
	add_child(money)

func get_random_floor_loc():
	var spawn_cell_index = randi() % money_spawn_locs.size()
	return money_spawn_locs[spawn_cell_index] + Vector2(8, 8)

func get_random_spawn_loc():
	var spawn_loc_index = randi() % npc_spawn_locs.size()
	return npc_spawn_locs[spawn_loc_index] + Vector2(8, 8)

func npc_spawn(spawn_index = -1):
	var spawn_loc
	if spawn_index == -1:
		spawn_loc = get_random_spawn_loc()
	else:
		spawn_loc = npc_spawn_locs[spawn_index] + Vector2(8, 8)
	
	var new_npc_scene = preload("res://npc.tscn").instance()
	new_npc_scene.set_global_pos(spawn_loc)
	var target_loc = get_random_floor_loc()
	new_npc_scene.target_coords = target_loc
	add_child(new_npc_scene)
