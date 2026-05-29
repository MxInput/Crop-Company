extends TileMapLayer

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")
@onready var overview: Control = get_node("/root/Game/Overview")

@onready var watered: TileMapLayer = get_node("/root/Game/Watered")

@onready var tree_placement = get_child(0)
@onready var tree_placement_sprite = tree_placement.get_child(0)
@onready var plant_check = tree_placement.get_child(2)
@onready var ground_check = tree_placement.get_child(1)

@onready var able_to_place = preload("res://tiles/toolbar/trees/able.png")
@onready var unable_to_place = preload("res://tiles/toolbar/trees/unable.png")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

var plant_info = {
	"Watermelon": {
		"stage1": { "sec": 20, "tile_id": 3},
		"stage2": { "sec": 30, "tile_id": 2},
		"stage3": { "sec": 40, "tile_id": 0},
		"stage4": {"tile_id": 1},
		"price": 12,
		"sell": 30,
		"icon": load("res://tiles/toolbar/fruits/watermelon_icon.png")
	},
	"Carrot": {
		"stage1": { "sec": 10, "tile_id": 7},
		"stage2": { "sec": 20, "tile_id": 6},
		"stage3": { "sec": 30, "tile_id": 4},
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
		"price": 30,
		"sell": 50,
		"icon": load("res://tiles/toolbar/fruits/pumpkin_icon.png")
	},
	"Butternut Squash": {
		"stage1": { "sec": 25, "tile_id": 15},
		"stage2": { "sec": 30, "tile_id": 14},
		"stage3": { "sec": 35, "tile_id": 12},
		"stage4": {"tile_id": 13},
		"price": 18,
		"sell": 28,
		"icon": load("res://tiles/toolbar/fruits/butternut_icon.png")
	}
}

var tree_info = {
	"Apple": {
		"stage1": { "sec": 10, "tile_id": 19},
		"stage2": { "sec": 10, "tile_id": 18},
		"stage3": { "sec": 10, "tile_id": 16},
		"stage4": {"sec": 5, "tile_id": 17},
		"stage5": {"tile_id": 20},
		"price": 50,
		"sell": 10,
		"icon": load("res://tiles/toolbar/trees/Apple_Icon.png")
	},
	"Grapefruit": {
		"stage1": { "sec": 20, "tile_id": 30},
		"stage2": { "sec": 20, "tile_id": 29},
		"stage3": { "sec": 20, "tile_id": 26},
		"stage4": {"sec": 10, "tile_id": 27},
		"stage5": {"tile_id": 28},
		"price": 100,
		"sell": 20,
		"icon": load("res://tiles/toolbar/trees/grapefruit_icon.png")
	},
	"Banana": {
		"stage1": { "sec": 16, "tile_id": 25},
		"stage2": { "sec": 16, "tile_id": 24},
		"stage3": { "sec": 16, "tile_id": 21},
		"stage4": {"sec": 8, "tile_id": 22},
		"stage5": {"tile_id": 23},
		"price": 75,
		"sell": 15,
		"icon": load("res://tiles/toolbar/trees/banana_icon.png")
	}
}

var plant_data = {}
	
func move_placement():
	tree_placement.visible = true
	tree_placement.position = (get_local_mouse_position())
	tree_placement_sprite.texture = able_to_place
	
	if plant_check.has_overlapping_bodies:
		for body in plant_check.get_overlapping_bodies():
			if body.name == name:
				tree_placement_sprite.texture = unable_to_place
			elif ground_check.has_overlapping_bodies:
				for ground in ground_check.get_overlapping_bodies():
					if ground.name == terrain.name:
						tree_placement_sprite.texture = unable_to_place
						
	
func plant(plant_name) -> void:
	var local_pos = terrain.to_local(get_global_mouse_position())
	var cell_pos = terrain.local_to_map(local_pos)
	var tile_id = (terrain.get_cell_source_id(cell_pos))

	var self_tile_id = get_cell_source_id(cell_pos)

	if tree_info.get(plant_name):
		if tree_placement_sprite.texture == able_to_place:
			if PlayerVariables.player.buy(tree_info[plant_name]["price"]):
				coin_display.new_instance(-tree_info[plant_name]["price"])
				for x in 3:
					for y in 4:
						plant_data[cell_pos + Vector2i(x-1, y-2)] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0, "type": "tree", "initial": cell_pos}
						set_cell(cell_pos + Vector2i(x-1, y-2), tree_info[plant_name]["stage1"]["tile_id"], Vector2i(x, y))
	else:
		if (self_tile_id == -1):
			if (tile_id == 1 || tile_id == 2):
				if PlayerVariables.player.buy(plant_info[plant_name]["price"]):
					coin_display.new_instance(-plant_info[plant_name]["price"])
					plant_data[cell_pos] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0, "type": "crop"}
					set_cell(cell_pos, plant_info[plant_name]["stage1"]["tile_id"], Vector2i(0, 0))
				
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	
	for watered_tile in terrain.watered_tiles:
		if watered.get_cell_source_id(watered_tile) == -1:
			if plant_data.get(watered_tile):
				if plant_data[watered_tile]["type"] == "crop":
					watered.set_cell(watered_tile, 0, Vector2i(0, 0))
				else:
					for x in 3:
						for y in 4:
							watered.set_cell(plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2), 0, Vector2i(0, 0))
							if !terrain.watered_tiles.get(plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2)):
								terrain.watered_tiles[plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2)] = {"time": terrain.watered_tiles[watered_tile]["time"] }
		elif !plant_data.get(watered_tile):
				terrain.watered_tiles.erase(watered_tile)
				watered.erase_cell(watered_tile)
		if plant_data.get(watered_tile):
			if plant_data[watered_tile]["type"] == "tree":
				if terrain.watered_tiles.get(plant_data[watered_tile]["initial"]):
					if terrain.watered_tiles[watered_tile]["time"] != terrain.watered_tiles[plant_data[watered_tile]["initial"]]["time"]:
						terrain.watered_tiles[watered_tile]["time"] = terrain.watered_tiles[plant_data[watered_tile]["initial"]]["time"]
	if Input.is_action_pressed("click"):
		if (plant_data.has(cell_pos)):
			if ToolVariables.current_tool == "Shovel":
				if plant_data[cell_pos]["type"] == "crop":
					PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["price"])
					coin_display.new_instance(plant_info[plant_data[cell_pos]["fruit_name"]]["price"])			
				else:
					if plant_data[plant_data[cell_pos]["initial"]]["stage"] == 5:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])			
					else:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["price"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["price"])	
			else:
				if plant_data[cell_pos]["type"] == "crop":
					if plant_data[cell_pos]["stage"] == 4:
						PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])	
				elif plant_data[cell_pos]["type"] == "tree":
					if plant_data[plant_data[cell_pos]["initial"]]["stage"] == 5:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])	
			if ToolVariables.current_tool == "Shovel" or plant_data[cell_pos]["stage"] >= 4 or plant_data[cell_pos].has("initial"):
				if plant_data[cell_pos]["type"] == "crop": 
					plant_data.erase(cell_pos)
					erase_cell(cell_pos)
					terrain.set_cell(cell_pos, 0, Vector2i(0,0))
				elif plant_data[cell_pos]["type"] == "tree":
					if plant_data[plant_data[cell_pos]["initial"]]["stage"] == 5 and ToolVariables.current_tool != "Shovel":
						for x in 3:
							for y in 4:
								plant_data[plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2)]["stage"] -= 1
								set_cell(plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2), tree_info[plant_data[cell_pos]["fruit_name"]]["stage4"]["tile_id"], Vector2i(x, y))	
					elif ToolVariables.current_tool == "Shovel":
						var initial = plant_data[cell_pos]["initial"]
						for x in 3:
							for y in 4:
								if terrain.watered_tiles.get(initial + Vector2i(x-1, y-2)):
									terrain.watered_tiles.erase(initial + Vector2i(x-1, y-2))
								terrain.set_cell(initial + Vector2i(x-1, y-2), 0, Vector2i(0,0))
								if watered.get_cell_source_id(initial + Vector2i(x-1, y-2))	!= -1:
									watered.erase_cell(initial + Vector2i(x-1, y-2))
								erase_cell(initial + Vector2i(x-1, y-2))
								plant_data.erase(initial + Vector2i(x-1, y-2))
	if (plant_data.has(cell_pos)):
		var timeLeft 
			
		if plant_data[cell_pos]["type"] == "crop":
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
		else:
			match plant_data[plant_data[cell_pos]["initial"]]["stage"]: 
				1:
					var goal = tree_info[plant_data[cell_pos]["fruit_name"]]["stage1"]["sec"]
					timeLeft = goal - plant_data[plant_data[cell_pos]["initial"]]["time"]
				2:
					var goal = tree_info[plant_data[cell_pos]["fruit_name"]]["stage2"]["sec"]
					timeLeft = goal - plant_data[plant_data[cell_pos]["initial"]]["time"]
				3:
					var goal = tree_info[plant_data[cell_pos]["fruit_name"]]["stage3"]["sec"]
					timeLeft = goal - plant_data[plant_data[cell_pos]["initial"]]["time"]
				4:
					var goal = tree_info[plant_data[cell_pos]["fruit_name"]]["stage4"]["sec"]
					timeLeft = goal - plant_data[plant_data[cell_pos]["initial"]]["time"]
				_:
					timeLeft = 0
		if plant_data[cell_pos]["type"] == "crop":
			overview.display(str(plant_data[cell_pos]["stage"]), str(plant_data[cell_pos]["type"]), plant_data[cell_pos]["fruit_name"], str(ceil(timeLeft)))
		else:
			overview.display(str(plant_data[plant_data[cell_pos]["initial"]]["stage"]), str(plant_data[cell_pos]["type"]), plant_data[cell_pos]["fruit_name"], str(ceil(timeLeft)))
	else:
		overview.deactivate("plants")
		
	for found_plant in plant_data:
		var stage = plant_data[found_plant]["stage"]
		var type = plant_data[found_plant]["type"]
		if type == "crop":
			if stage < 4:
				if terrain.watered_tiles.get(found_plant):
					plant_data[found_plant]["time"] += delta
				match stage:
					1:
						var goal = plant_info[plant_data[found_plant]["fruit_name"]]["stage1"]["sec"]
						if plant_data[found_plant]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[found_plant]["time"] = 0
							set_cell(found_plant, plant_info[plant_data[found_plant]["fruit_name"]]["stage2"]["tile_id"], Vector2i(0, 0))
					2:
						var goal = plant_info[plant_data[found_plant]["fruit_name"]]["stage2"]["sec"]
						if plant_data[found_plant]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[found_plant]["time"] = 0
							set_cell(found_plant, plant_info[plant_data[found_plant]["fruit_name"]]["stage3"]["tile_id"], Vector2i(0, 0))
					3:
						var goal = plant_info[plant_data[found_plant]["fruit_name"]]["stage3"]["sec"]
						if plant_data[found_plant]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[found_plant]["time"] = 0
							set_cell(found_plant, plant_info[plant_data[found_plant]["fruit_name"]]["stage4"]["tile_id"], Vector2i(0, 0))
		else:
			if stage < 5:
				if terrain.watered_tiles.get(found_plant):
					if plant_data[found_plant]["initial"] == found_plant:
						plant_data[found_plant]["time"] += delta
				match stage:
					1:
						var goal = tree_info[plant_data[found_plant]["fruit_name"]]["stage1"]["sec"]
						var initial = plant_data[found_plant]["initial"]
						if plant_data[initial]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[initial]["time"] = 0
							for x in 3:
								for y in 4:
									set_cell(initial + Vector2i(x-1, y-2), tree_info[plant_data[found_plant]["fruit_name"]]["stage2"]["tile_id"], Vector2i(x, y))
					2:
						var goal = tree_info[plant_data[found_plant]["fruit_name"]]["stage2"]["sec"]
						var initial = plant_data[found_plant]["initial"]
						if plant_data[initial]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[initial]["time"] = 0
							for x in 3:
								for y in 4:
									set_cell(initial + Vector2i(x-1, y-2), tree_info[plant_data[found_plant]["fruit_name"]]["stage3"]["tile_id"], Vector2i(x, y))
					3:
						var goal = tree_info[plant_data[found_plant]["fruit_name"]]["stage3"]["sec"]
						var initial = plant_data[found_plant]["initial"]
						if plant_data[initial]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[initial]["time"] = 0
							for x in 3:
								for y in 4:
									set_cell(initial + Vector2i(x-1, y-2), tree_info[plant_data[found_plant]["fruit_name"]]["stage4"]["tile_id"], Vector2i(x, y))
					4:
						var goal = tree_info[plant_data[found_plant]["fruit_name"]]["stage4"]["sec"]
						var initial = plant_data[found_plant]["initial"]
						if plant_data[initial]["time"] >= goal:
							plant_data[found_plant]["stage"] += 1
							plant_data[initial]["time"] = 0
							for x in 3:
								for y in 4:
									set_cell(initial + Vector2i(x-1, y-2), tree_info[plant_data[found_plant]["fruit_name"]]["stage5"]["tile_id"], Vector2i(x, y))
