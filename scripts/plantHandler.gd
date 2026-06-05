extends TileMapLayer

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")
@onready var overview: Control = get_node("/root/Game/CanvasLayer/Overview")

@onready var watered: TileMapLayer = get_node("/root/Game/Watered")
@onready var fertilized: TileMapLayer = get_node("/root/Game/Fertilized")
@onready var infected: TileMapLayer = get_node("/root/Game/Pests")

@onready var tree_placement = get_child(0)
@onready var tree_placement_sprite = tree_placement.get_child(0)
@onready var plant_check = tree_placement.get_child(2)
@onready var ground_check = tree_placement.get_child(1)

@onready var upgrades: Node2D = get_node("/root/Game/Upgrades")
@onready var quests: Node2D = get_node("/root/Game/Quests")

@onready var tutorial = get_node("/root/Game/CanvasLayer/Tutorial")

var accounted_fertilized_tiles = []

@onready var able_to_place = preload("res://tiles/toolbar/trees/able.png")
@onready var unable_to_place = preload("res://tiles/toolbar/trees/unable.png")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

signal send_values

var plant_info = {
	"Watermelon": {
		"stage1": { "sec": 20, "tile_id": 3},
		"stage2": { "sec": 30, "tile_id": 2},
		"stage3": { "sec": 40, "tile_id": 0},
		"stage4": {"tile_id": 1},
		"price": 12,
		"sell": 30,
		"seasons": ["Summer"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/watermelon_icon.png")
	},
	"Carrot": {
		"stage1": { "sec": 10, "tile_id": 7},
		"stage2": { "sec": 20, "tile_id": 6},
		"stage3": { "sec": 30, "tile_id": 4},
		"stage4": {"tile_id": 5},
		"price": 5,
		"sell": 10,
		"seasons": ["Spring", "Summer", "Fall", "Winter"],
		"locked": false,
		"icon": load("res://tiles/toolbar/fruits/carrot_icon.png")
	},
	"Pumpkin": {
		"stage1": { "sec": 30, "tile_id": 11},
		"stage2": { "sec": 40, "tile_id": 8},
		"stage3": { "sec": 50, "tile_id": 9},
		"stage4": {"tile_id": 10},
		"price": 30,
		"sell": 50,
		"seasons": ["Fall"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/pumpkin_icon.png")
	},
	"Butternut Squash": {
		"stage1": { "sec": 25, "tile_id": 15},
		"stage2": { "sec": 30, "tile_id": 14},
		"stage3": { "sec": 35, "tile_id": 12},
		"stage4": {"tile_id": 13},
		"price": 18,
		"sell": 28,
		"seasons": ["Fall"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/butternut_icon.png")
	},
	"Tomato": {
		"stage1": { "sec": 25, "tile_id": 34},
		"stage2": { "sec": 30, "tile_id": 33},
		"stage3": { "sec": 35, "tile_id": 31},
		"stage4": {"tile_id": 32},
		"price": 18,
		"sell": 28,
		"seasons": ["Summer"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/tomato_icon.png")
	},
	"Beet": {
		"stage1": { "sec": 25, "tile_id": 38},
		"stage2": { "sec": 30, "tile_id": 37},
		"stage3": { "sec": 35, "tile_id": 35},
		"stage4": {"tile_id": 36},
		"price": 18,
		"sell": 28,
		"seasons": ["Spring", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/beet_icon.png")
	},
	"Cabbage": {
		"stage1": { "sec": 25, "tile_id": 42},
		"stage2": { "sec": 30, "tile_id": 41},
		"stage3": { "sec": 35, "tile_id": 39},
		"stage4": {"tile_id": 40},
		"price": 18,
		"sell": 28,
		"seasons": ["Spring", "Summer", "Fall"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/cabbage_icon.png")
	},
	"Kale": {
		"stage1": { "sec": 25, "tile_id": 46},
		"stage2": { "sec": 30, "tile_id": 45},
		"stage3": { "sec": 35, "tile_id": 44},
		"stage4": {"tile_id": 43},
		"price": 18,
		"sell": 28,
		"seasons": ["Spring", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/kale_icon.png")
	},
	"Potato": {
		"stage1": { "sec": 25, "tile_id": 50},
		"stage2": { "sec": 30, "tile_id": 49},
		"stage3": { "sec": 35, "tile_id": 47},
		"stage4": {"tile_id": 48},
		"price": 18,
		"sell": 28,
		"seasons": ["Spring", "Summer"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/potato_icon.png")
	},
	"Raddish": {
		"stage1": { "sec": 25, "tile_id": 54},
		"stage2": { "sec": 30, "tile_id": 53},
		"stage3": { "sec": 35, "tile_id": 51},
		"stage4": {"tile_id": 52},
		"price": 18,
		"sell": 28,
		"seasons": ["Spring", "Summer"],
		"locked": true,
		"icon": load("res://tiles/toolbar/fruits/raddish_icon.png")
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
		"seasons": ["Summer", "Fall"],
		"locked": true,
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
		"seasons": ["Spring", "Winter"],
		"locked": true,
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
		"seasons": ["Spring", "Summer", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/trees/banana_icon.png")
	},
	"Coconut": {
		"stage1": { "sec": 16, "tile_id": 59},
		"stage2": { "sec": 16, "tile_id": 58},
		"stage3": { "sec": 16, "tile_id": 55},
		"stage4": {"sec": 8, "tile_id": 57},
		"stage5": {"tile_id": 56},
		"price": 75,
		"sell": 15,
		"seasons": ["Spring", "Summer", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/trees/coconut_icon.png")
	},
	"Fig": {
		"stage1": { "sec": 16, "tile_id": 64},
		"stage2": { "sec": 16, "tile_id": 63},
		"stage3": { "sec": 16, "tile_id": 60},
		"stage4": {"sec": 8, "tile_id": 62},
		"stage5": {"tile_id": 61},
		"price": 75,
		"sell": 15,
		"seasons": ["Spring", "Summer", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/trees/fig_icon.png")
	},
	"Pomegranate": {
		"stage1": { "sec": 16, "tile_id": 69},
		"stage2": { "sec": 16, "tile_id": 68},
		"stage3": { "sec": 16, "tile_id": 65},
		"stage4": {"sec": 8, "tile_id": 67},
		"stage5": {"tile_id": 66},
		"price": 75,
		"sell": 15,
		"seasons": ["Spring", "Summer", "Fall", "Winter"],
		"locked": true,
		"icon": load("res://tiles/toolbar/trees/pomegranate_icon.png")
	}
}

var plant_data = {}
	
func get_carrot_count():
	var count = 0
	for found_plant in plant_data:
		if plant_data[found_plant]["fruit_name"] == "Carrot":
			count += 1
	return count
	
func get_banana_count():
	var count = 0
	for found_plant in plant_data:
		if plant_data[found_plant]["fruit_name"] == "Banana":
			if plant_data[found_plant]["initial"] == found_plant:
				count += 1
	return count
			
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
							
func plant(plant_name, tile_size) -> void:
	var local_pos = terrain.to_local(get_global_mouse_position())
	var cell_pos = terrain.local_to_map(local_pos)
	var tile_id = (terrain.get_cell_source_id(cell_pos))

	var self_tile_id = get_cell_source_id(cell_pos)

	if tree_info.has(plant_name):
		if tree_placement_sprite.texture == able_to_place:
			if tree_info[plant_name]["seasons"].has(SeasonVariables.season.name):
				if PlayerVariables.player.buy(tree_info[plant_name]["price"]):
					coin_display.new_instance(-tree_info[plant_name]["price"])
					for x in 3:
						for y in 4:
							plant_data[cell_pos + Vector2i(x-1, y-2)] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0, "type": "tree", "initial": cell_pos}
							set_cell(cell_pos + Vector2i(x-1, y-2), tree_info[plant_name]["stage1"]["tile_id"], Vector2i(x, y))
					if plant_name == "Banana":
						if quests.quests["Have 5 Banana Trees at once"]["Amount"] < quests.quests["Have 5 Banana Trees at once"]["Max"] && quests.quests["Have 5 Banana Trees at once"]["Amount"] < get_banana_count():
							quests.quests["Have 5 Banana Trees at once"]["Amount"] = get_banana_count()		
				else:
					coin_display.tell_warning("Not enough coins")
			else:
				coin_display.tell_warning("Can't grow this season")
	else:
		if (self_tile_id == -1) or tile_size == 9:
			if (tile_id == 1 || tile_id == 2):
				if plant_info[plant_name]["seasons"].has(SeasonVariables.season.name):
					if tile_size == 1:
						if PlayerVariables.player.buy(plant_info[plant_name]["price"]):
							coin_display.new_instance(-plant_info[plant_name]["price"])
							plant_data[cell_pos] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0, "type": "crop"}
							set_cell(cell_pos, plant_info[plant_name]["stage1"]["tile_id"], Vector2i(0, 0))
						else:
							coin_display.tell_warning("Not enough coins")
					else:
						var total = 0
						var space_issue = 0
						for x in 3:
							for y in 3:
								var focused_tile = cell_pos + Vector2i(x-1, y-1)
								if !plant_data.has(focused_tile) && terrain.get_cell_source_id(focused_tile) != 0:
									if PlayerVariables.player.buy(plant_info[plant_name]["price"]):
										total += 1
										plant_data[focused_tile] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0, "type": "crop"}
										set_cell(focused_tile, plant_info[plant_name]["stage1"]["tile_id"], Vector2i(0, 0))
								else:
									space_issue += 1
						if total > 0:
							coin_display.new_instance(-(plant_info[plant_name]["price"] * total))			
						else:
							if space_issue == 9:
								coin_display.tell_warning("Not enough space")	
							else:
								coin_display.tell_warning("Not enough coins")	
				else:
					coin_display.tell_warning("Can't grow this season")

func _ready() -> void:
	send_values.connect(tutorial.change)
			
func _process(delta: float) -> void:
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 16:
		if get_carrot_count() >= 18:
			send_values.emit()
			
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 21:
		if terrain.fertilized_tiles.keys().size() >= 17:
			send_values.emit()			
			
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 22:
		if terrain.watered_tiles.keys().size() >= 17:
			send_values.emit()			
			
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 25:
		if get_banana_count() >= 1:
			send_values.emit()		
		
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 24:
		var count = 0
		for plant in plant_data:
			if plant_data[plant]["fruit_name"] == "Carrot":
				set_cell(plant, plant_info[plant_data[plant]["fruit_name"]]["stage4"]["tile_id"], Vector2i(0, 0))
				plant_data[plant]["stage"] = 4
				plant_data[plant]["time"] = 0
			if count >= 17:
				break		
										
	for infected_tile in terrain.infected_tiles:
		if !plant_data.has(infected_tile):
			terrain.infected_tiles.erase(infected_tile)
			infected.erase_cell(infected_tile)
					
	for fertilized_tile in terrain.fertilized_tiles:
		if !plant_data.has(fertilized_tile):
				terrain.fertilized_tiles.erase(fertilized_tile)
				fertilized.erase_cell(fertilized_tile)
				if accounted_fertilized_tiles.has(fertilized_tile):
					accounted_fertilized_tiles.erase(fertilized_tile)
				
		if plant_data.has(fertilized_tile):
			var goal = 0
			if plant_info.has(plant_data[fertilized_tile]["fruit_name"]):
				if !accounted_fertilized_tiles.has(fertilized_tile):
					accounted_fertilized_tiles.append(fertilized_tile)
					
					match plant_data[fertilized_tile]["stage"]:
						1:
							goal = plant_info[plant_data[fertilized_tile]["fruit_name"]]["stage1"]["sec"]
						2:
							goal = plant_info[plant_data[fertilized_tile]["fruit_name"]]["stage2"]["sec"]
						3:
							goal = plant_info[plant_data[fertilized_tile]["fruit_name"]]["stage3"]["sec"]
					if goal != 0:
						var time_left = goal - plant_data[fertilized_tile]["time"]
						plant_data[fertilized_tile]["time"] = plant_data[fertilized_tile]["time"] + floor(time_left * upgrades.upgrades["Better Fertilized"]["Percentages"][upgrades.upgrades["Better Fertilized"]["Level"]-1])
			else:		
				if fertilized_tile == plant_data[fertilized_tile]["initial"]:
					if !accounted_fertilized_tiles.has(fertilized_tile):
						accounted_fertilized_tiles.append(fertilized_tile)
						match plant_data[fertilized_tile]["stage"]:
							1:
								goal = tree_info[plant_data[fertilized_tile]["fruit_name"]]["stage1"]["sec"]
							2:
								goal = tree_info[plant_data[fertilized_tile]["fruit_name"]]["stage2"]["sec"]
							3:
								goal = tree_info[plant_data[fertilized_tile]["fruit_name"]]["stage3"]["sec"]
							4:
								goal = tree_info[plant_data[fertilized_tile]["fruit_name"]]["stage3"]["sec"]
						if goal != 0:
							var time_left = goal - plant_data[fertilized_tile]["time"]
							plant_data[fertilized_tile]["time"] = plant_data[fertilized_tile]["time"] + floor(time_left * 1 / 4)
	for watered_tile in terrain.watered_tiles:
		if watered.get_cell_source_id(watered_tile) == -1:
			if plant_data.has(watered_tile):
				if plant_data[watered_tile]["type"] == "crop":
					watered.set_cell(watered_tile, 0, Vector2i(0, 0))
				else:
					for x in 3:
						for y in 4:
							watered.set_cell(plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2), 0, Vector2i(0, 0))
							if !terrain.watered_tiles.has(plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2)):
								terrain.watered_tiles[plant_data[cell_pos]["initial"] + Vector2i(x-1, y-2)] = {"time": terrain.watered_tiles[watered_tile]["time"] }
		elif !plant_data.has(watered_tile):
				terrain.watered_tiles.erase(watered_tile)
				watered.erase_cell(watered_tile)
		if plant_data.has(watered_tile):
			if plant_data[watered_tile]["type"] == "tree":
				if terrain.watered_tiles.has(plant_data[watered_tile]["initial"]):
					if terrain.watered_tiles[watered_tile]["time"] != terrain.watered_tiles[plant_data[watered_tile]["initial"]]["time"]:
						terrain.watered_tiles[watered_tile]["time"] = terrain.watered_tiles[plant_data[watered_tile]["initial"]]["time"]
	if Input.is_action_pressed("click"):
		if (plant_data.has(cell_pos)):
			if ToolVariables.current_tool == "Shovel":
				if plant_data[cell_pos]["type"] == "crop":
					if plant_data[cell_pos]["stage"] == 4:
						PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])			
						
						if !PlayerVariables.player.completed_tutorial && tutorial.place == 24:
							send_values.emit()
						
						quests.quests["Harvest 80 Crops"]["Amount"] += 1
						
						quests.quests["Harvest plants worth a total of 1000 coins"]["Amount"] += plant_info[plant_data[cell_pos]["fruit_name"]]["sell"]
						quests.quests["Harvest plants worth a total of 5000 coins"]["Amount"] += plant_info[plant_data[cell_pos]["fruit_name"]]["sell"]
					else:
						PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["price"])
						coin_display.new_instance(plant_info[plant_data[cell_pos]["fruit_name"]]["price"])			
				else:
					if plant_data[plant_data[cell_pos]["initial"]]["stage"] == 5:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])			
						quests.quests["Harvest 80 Crops"]["Amount"] += 1
						quests.quests["Harvest plants worth a total of 1000 coins"]["Amount"] += tree_info[plant_data[cell_pos]["fruit_name"]]["sell"]
						quests.quests["Harvest plants worth a total of 5000 coins"]["Amount"] += tree_info[plant_data[cell_pos]["fruit_name"]]["sell"]
					else:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["price"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["price"])	
			else:
				if plant_data[cell_pos]["type"] == "crop":
					if plant_data[cell_pos]["stage"] == 4:
						PlayerVariables.player.sell(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(plant_info[plant_data[cell_pos]["fruit_name"]]["sell"])	
					
						if !PlayerVariables.player.completed_tutorial && tutorial.place == 24:
							send_values.emit()
							
						quests.quests["Harvest 80 Crops"]["Amount"] += 1
						quests.quests["Harvest plants worth a total of 1000 coins"]["Amount"] += plant_info[plant_data[cell_pos]["fruit_name"]]["sell"]
						quests.quests["Harvest plants worth a total of 5000 coins"]["Amount"] += plant_info[plant_data[cell_pos]["fruit_name"]]["sell"]
				elif plant_data[cell_pos]["type"] == "tree":
					if plant_data[plant_data[cell_pos]["initial"]]["stage"] == 5:
						PlayerVariables.player.sell(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])
						coin_display.new_instance(tree_info[plant_data[cell_pos]["fruit_name"]]["sell"])	
						quests.quests["Harvest 80 Crops"]["Amount"] += 1
						quests.quests["Harvest plants worth a total of 1000 coins"]["Amount"] += tree_info[plant_data[cell_pos]["fruit_name"]]["sell"]
						quests.quests["Harvest plants worth a total of 5000 coins"]["Amount"] += tree_info[plant_data[cell_pos]["fruit_name"]]["sell"]
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
								if terrain.watered_tiles.has(initial + Vector2i(x-1, y-2)):
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
				if plant_info[plant_data[found_plant]["fruit_name"]]["seasons"].has(SeasonVariables.season.name):
					if terrain.watered_tiles.has(found_plant) && !terrain.infected_tiles.has(found_plant):
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
				if tree_info[plant_data[found_plant]["fruit_name"]]["seasons"].has(SeasonVariables.season.name):
					if terrain.watered_tiles.has(found_plant) && !terrain.infected_tiles.has(found_plant):
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
