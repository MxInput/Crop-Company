extends TileMapLayer

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")
@onready var overview: Control = get_node("/root/Game/Overview")

var plant_info = {
	"Watermelon": {
		"stage1": { "sec": 10, "tile_id": 3},
		"stage2": { "sec": 20, "tile_id": 2},
		"stage3": { "sec": 30, "tile_id": 0},
		"stage4": {"tile_id": 1},
		"price": 5,
		"sell": 10,
		"icon": load("res://tiles/toolbar/fruits/watermelon_icon.png")
	},
	"Carrot": {
		"stage1": { "sec": 30, "tile_id": 7},
		"stage2": { "sec": 40, "tile_id": 6},
		"stage3": { "sec": 50, "tile_id": 4},
		"stage4": {"tile_id": 5},
		"price": 5,
		"sell": 10,
		"icon": load("res://tiles/toolbar/fruits/carrot_icon.png")
	},
	"Pumpkin": {
		"stage1": { "sec": 30, "tile_id": 11},
		"stage2": { "sec": 40, "tile_id": 8},
		"stage3": { "sec": 50, "tile_id": 9},
		"stage4": {"tile_id": 10},
		"price": 5,
		"sell": 10,
		"icon": load("res://tiles/toolbar/fruits/pumpkin_icon.png")
	},
	"Butternut Squash": {
		"stage1": { "sec": 30, "tile_id": 15},
		"stage2": { "sec": 40, "tile_id": 14},
		"stage3": { "sec": 50, "tile_id": 12},
		"stage4": {"tile_id": 13},
		"price": 5,
		"sell": 10,
		"icon": load("res://tiles/toolbar/fruits/butternut_icon.png")
	}
}

var tree_info = {
	"Apple": {
		"stage1": { "sec": 30, "tile_id": 19},
		"stage2": { "sec": 40, "tile_id": 8},
		"stage3": { "sec": 50, "tile_id": 9},
		"stage4": {"tile_id": 10},
		"icon": load("res://tiles/toolbar/trees/Apple_Icon.png")
	}
}

var plant_data = {}
	
func get_surrounding_tiles(current_tile, tree):
	var tiles = [current_tile - Vector2i(2, 0), current_tile - Vector2i(1, 0), current_tile, current_tile + Vector2i(1, 0), current_tile + Vector2i(2, 0)]
	if terrain.get_cell_source_id(tiles[0]) == 1 && terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1:
		for x in 5:
			tiles[x] = tiles[x] + Vector2i.UP
		if terrain.get_cell_source_id(tiles[0]) == 1 && terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1:
			set_cell(tiles[0], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
			set_cell(tiles[1], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
			set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
			
			set_cell(tiles[0] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
			set_cell(tiles[1] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
			set_cell(tiles[2] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
			return true
		else:	
			for x in 5:
				tiles[x] = tiles[x] + 2 * Vector2i.DOWN
			if terrain.get_cell_source_id(tiles[0]) == 1 && terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1:
				set_cell(tiles[0], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
				set_cell(tiles[1], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
				set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
				
				set_cell(tiles[0] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
				set_cell(tiles[1] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
				set_cell(tiles[2] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
				return true
	tiles = [current_tile - Vector2i(2, 0), current_tile - Vector2i(1, 0), current_tile, current_tile + Vector2i(1, 0), current_tile + Vector2i(2, 0)]
	if terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1:
		for x in 5:
			tiles[x] = tiles[x] + Vector2i.UP
		if terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1:
			set_cell(tiles[1], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
			set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
			set_cell(tiles[3], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
			
			set_cell(tiles[1] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
			set_cell(tiles[2] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
			set_cell(tiles[3] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
			return true
		else:	
			for x in 5:
				tiles[x] = tiles[x] + 2 * Vector2i.DOWN
			if terrain.get_cell_source_id(tiles[1]) == 1 && terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1:
				set_cell(tiles[1], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
				set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
				set_cell(tiles[3], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
				
				set_cell(tiles[1] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
				set_cell(tiles[2] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
				set_cell(tiles[3] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
				return true
	tiles = [current_tile - Vector2i(2, 0), current_tile - Vector2i(1, 0), current_tile, current_tile + Vector2i(1, 0), current_tile + Vector2i(2, 0)]
	if terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1 && terrain.get_cell_source_id(tiles[4]) == 1:
		for x in 5:
			tiles[x] = tiles[x] + Vector2i.UP
		if terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1 && terrain.get_cell_source_id(tiles[4]) == 1:
			set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
			set_cell(tiles[3], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
			set_cell(tiles[4], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
			
			set_cell(tiles[2] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
			set_cell(tiles[3] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
			set_cell(tiles[4] - Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
			return true
		else:	
			for x in 5:
				tiles[x] = tiles[x] + 2 * Vector2i.DOWN
			if terrain.get_cell_source_id(tiles[2]) == 1 && terrain.get_cell_source_id(tiles[3]) == 1 && terrain.get_cell_source_id(tiles[4]) == 1:
				set_cell(tiles[2], tree_info[tree]["stage1"]["tile_id"], Vector2i(0,3))
				set_cell(tiles[3], tree_info[tree]["stage1"]["tile_id"], Vector2i(1,3))
				set_cell(tiles[4], tree_info[tree]["stage1"]["tile_id"], Vector2i(2,3))
				
				set_cell(tiles[2] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(0,2))
				set_cell(tiles[3] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(1,2))
				set_cell(tiles[4] + Vector2i(0, -1), tree_info[tree]["stage1"]["tile_id"], Vector2i(2,2))
				return true
	return false
	
func plant(plant_name) -> void:
	var local_pos = terrain.to_local(get_global_mouse_position())
	var cell_pos = terrain.local_to_map(local_pos)
	var tile_id = (terrain.get_cell_source_id(cell_pos))

	var self_tile_id = get_cell_source_id(cell_pos)

	if tree_info.get(plant_name):
		get_surrounding_tiles(cell_pos, plant_name)
	else:
		if PlayerVariables.player.buy(plant_info[plant_name]["price"]):
			if (self_tile_id == -1):
				if (tile_id == 1):
					plant_data[cell_pos] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0}
					set_cell(cell_pos, plant_info[plant_name]["stage1"]["tile_id"], Vector2i(0, 0))
		
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	
	if Input.is_action_pressed("click"):
		if (plant_data.has(cell_pos)):
			if plant_data[cell_pos]["stage"] == 4: 
				PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])
				plant_data.erase(cell_pos)
				set_cell(cell_pos, -1, Vector2i(0,0))
				terrain.set_cell(cell_pos, 0, Vector2i(0,0))
				
	if (plant_data.has(cell_pos)):
		var timeLeft 
			
		match plant_data[cell_pos]["stage"]: 
			1:
				var goal = plant_info[plant_data[cell_pos]["fruit_name"]]["stage1"]["sec"]
				timeLeft = goal - plant_data[cell_pos]["time"]
			2:
				var goal = plant_info[plant_data[cell_pos]["fruit_name"]]["stage2"]["sec"]
				timeLeft = goal - plant_data[cell_pos]["time"]
			3:
				var goal = plant_info[plant_data[cell_pos]["fruit_name"]]["stage3"]["sec"]
				timeLeft = goal - plant_data[cell_pos]["time"]
			_:
				timeLeft = 0
		overview.display(str(plant_data[cell_pos]["stage"]), plant_data[cell_pos]["fruit_name"], str(ceil(timeLeft)))
	else:
		overview.visible = false
		
	for plant in plant_data:
		var stage = plant_data[plant]["stage"]
		if stage < 4:
			plant_data[plant]["time"] += delta
			match stage:
				1:
					var goal = plant_info[plant_data[plant]["fruit_name"]]["stage1"]["sec"]
					if plant_data[plant]["time"] >= goal:
						plant_data[plant]["stage"] += 1
						plant_data[plant]["time"] = 0
						set_cell(plant, plant_info[plant_data[plant]["fruit_name"]]["stage2"]["tile_id"], Vector2i(0, 0))
				2:
					var goal = plant_info[plant_data[plant]["fruit_name"]]["stage2"]["sec"]
					if plant_data[plant]["time"] >= goal:
						plant_data[plant]["stage"] += 1
						plant_data[plant]["time"] = 0
						set_cell(plant, plant_info[plant_data[plant]["fruit_name"]]["stage3"]["tile_id"], Vector2i(0, 0))
				3:
					var goal = plant_info[plant_data[plant]["fruit_name"]]["stage3"]["sec"]
					if plant_data[plant]["time"] >= goal:
						plant_data[plant]["stage"] += 1
						plant_data[plant]["time"] = 0
						set_cell(plant, plant_info[plant_data[plant]["fruit_name"]]["stage4"]["tile_id"], Vector2i(0, 0))
				
	
