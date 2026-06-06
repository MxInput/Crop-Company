extends Node

@onready var quest_menu = get_node("/root/Game/CanvasLayer/QuestMenu")
@onready var upgrade_menu = get_node("/root/Game/CanvasLayer/UpgradesMenu")

const SAVE_PATH := "user://simple_save.tres"

var save_game: SaveGame = null

@onready var pathMaker := get_node("/root/Game/Paths")

signal new_bot_spawned

@onready var buy_bot : Node = get_node("/root/Game/CanvasLayer/BuyBot")

var timer = Timer.new()
var can_click = false

func _ready() -> void:
	add_child(timer)
	timer.one_shot = true
	timer.wait_time = 2.0
	timer.timeout.connect(change_text_back)
	
	new_bot_spawned.connect(pathMaker._on_buy_bot_new_bot_purchased)
	
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		save_game = SaveGame.new()
	
func save() -> void:
	var terrain : TileMapLayer = get_node("/root/Game/Terrain")
	
	save_game = SaveGame.new()
	
	save_game.player_coins = PlayerVariables.player.coins
	save_game.player_completed_tutorial = PlayerVariables.player.completed_tutorial
	
	save_game.season_name = SeasonVariables.season.name
	save_game.season_time_in = SeasonVariables.season.time_in

	var robots = get_tree().get_nodes_in_group("Water_Robots")
	var fertillBots = get_tree().get_nodes_in_group("fertillBots")
	var pestBots = get_tree().get_nodes_in_group("pestBot")
	var pickupBots = get_tree().get_nodes_in_group("pickupBot")

	save_game.terrain = {
		"Tilled": terrain.get_used_cells_by_id(1),
		"Watered Tilled": terrain.get_used_cells_by_id(2),
		"Watered Tiles": terrain.watered_tiles,
		"Fertilized Tiles": terrain.fertilized_tiles,
		"Infested Tiles":terrain.infected_tiles
	}
	
	save_game.plants = {
		"Plant Info": get_node("/root/Game/Plants").plant_info,
		"Plant Data": get_node("/root/Game/Plants").plant_data,
		"Tree Info": get_node("/root/Game/Plants").tree_info,
		"Accounted Fertilized Tiles": get_node("/root/Game/Plants").accounted_fertilized_tiles
	}
	
	save_game.robots = {
		"Waterbots": robots.size(),
		"FertillBots": fertillBots.size(),
		"pestBots": pestBots.size(),
		"pickupBots": pickupBots.size()
	}
	
	save_game.upgrades = get_node("/root/Game/Upgrades").upgrades
	
	save_game.quests = get_node("/root/Game/Quests").quests
	
	ResourceSaver.save(save_game, SAVE_PATH)	

func load_game():
	var plants : TileMapLayer = get_node("/root/Game/Plants")
	var terrain : TileMapLayer = get_node("/root/Game/Terrain")
	var toolbar = get_node("/root/Game/CanvasLayer/Toolbar")
	
	save_game = ResourceLoader.load(SAVE_PATH)	
	
	if save_game != null:
		PlayerVariables.player.coins = save_game.player_coins
		PlayerVariables.player.completed_tutorial = save_game.player_completed_tutorial
		
		SeasonVariables.season.name = save_game.season_name
		SeasonVariables.season.time_in = save_game.season_time_in

		SeasonVariables.clock.texture = SeasonVariables.season_clocks[SeasonVariables.season.name]
		
		get_node("/root/Game/Quests").quests = save_game.quests
		
		get_node("/root/Game/Upgrades").upgrades = save_game.upgrades
		for upgrade in save_game.upgrades:
			if save_game.upgrades[upgrade]["Level"] > 1:
				upgrade_menu.get_child(1).get_child(0).get_node(upgrade).get_child(1).text = "Level " + str(save_game.upgrades[upgrade]["Level"])
			
			if save_game.upgrades[upgrade]["Level"] < 3:
				upgrade_menu.get_child(1).get_child(0).get_node(upgrade).get_child(3).text = str(save_game.upgrades[upgrade]["Prices"][save_game.upgrades[upgrade]["Level"]]) + " coins"
			else:
				upgrade_menu.get_child(1).get_child(0).get_node(upgrade).get_child(3).text = "Max Level"
				
		for quest in save_game.quests:
			quest_menu.update_value(quest_menu.get_child(0).get_child(0).get_node(quest))
			if save_game.quests[quest]["Took"]:
				quest_menu.get_child(0).get_child(0).get_node(quest).get_child(4).get_child(0).text = "Collected"	
				if quest == "Harvest 80 Crops":
					buy_bot.visible = true
					
		for plant in save_game.plants["Plant Info"]:
			if save_game.plants["Plant Info"][plant]["locked"] == false:
				if plant != "Carrot":
					toolbar.unlock_plant([plant])
					
		for tree in save_game.plants["Tree Info"]:
			if save_game.plants["Tree Info"][tree]["locked"] == false:
				toolbar.unlock_plant([tree])
								
		plants.plant_info = save_game.plants["Plant Info"] 
		plants.plant_data = save_game.plants["Plant Data"]  
		plants.tree_info = save_game.plants["Tree Info"] 
		plants.accounted_fertilized_tiles = save_game.plants["Accounted Fertilized Tiles"]   
		  
		terrain.watered_tiles = save_game.terrain["Watered Tiles"] 
		terrain.fertilized_tiles = save_game.terrain["Fertilized Tiles"]  
		terrain.infected_tiles = save_game.terrain["Infested Tiles"] 
					
		for tile in save_game.terrain["Tilled"]:
			terrain.set_cell(tile, 1, Vector2i(0,0))
			
		for tile in save_game.terrain["Watered Tilled"]:
			terrain.set_cell(tile, 2, Vector2i(0,0))
			
		for fertilized in terrain.fertilized_tiles:
			terrain.fertilized.set_cell(fertilized, 0, Vector2i(0,0))
		
		for pest in terrain.infected_tiles:
			terrain.infected.set_cell(pest, 0, Vector2i(0,0))
		
					
		for plant in plants.plant_data:
			if plants.plant_data[plant]["type"] == "crop":
				plants.set_cell(plant, plants.plant_info[plants.plant_data[plant]["fruit_name"]]["stage" + str(plants.plant_data[plant]["stage"])]["tile_id"], Vector2i(0,0))
			else:
				if plants.plant_data[plant]["initial"] == plant:
					for x in 3:
						for y in 4:
							plants.set_cell(plant + Vector2i(x-1, y-2), plants.tree_info[plants.plant_data[plant]["fruit_name"]]["stage" + str(plants.plant_data[plant]["stage"])]["tile_id"], Vector2i(x, y))
		for robot in save_game.robots:
			for number in save_game.robots[robot]:
				var robot_name
				match robot:
					"Waterbots":
						robot_name = "Water"
					"FertillBots":
						robot_name = "Fertilize"
					"pestBots":
						robot_name = "Pest"
					"pickupBots":	
						robot_name = "Pickup"
						
				var new_bot = buy_bot.robots[robot_name]["Asset"].instantiate()
				get_parent().add_child(new_bot)
				new_bot.position = Vector2i(16, 16)	
				
				new_bot_spawned.emit(robot_name)

func change_save_text():
	var save_button = get_node("/root/Game/CanvasLayer/Save")
	save_button.get_child(0).text = "SAVED"
	
func change_text_back():
	timer.stop()
	
	var save_button = get_node("/root/Game/CanvasLayer/Save")
	save_button.get_child(0).text = "SAVE"
	
func _on_save_pressed() -> void:
	var save_button = get_node("/root/Game/CanvasLayer/Save")
	
	if timer.is_stopped():
		change_save_text()
		timer.start()
		
	save()
