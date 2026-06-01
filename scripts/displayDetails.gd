extends Control

@onready var plants : TileMapLayer = get_node("/root/Game/Plants")

@onready var stageTeller = get_child(0).get_child(3)
@onready var nameTeller = get_child(0).get_child(4)
@onready var timeTeller = get_child(0).get_child(5)
@onready var seasonTeller = get_child(0).get_child(6)

@onready var sellTeller = get_child(0).get_child(1)
@onready var priceTeller = get_child(0).get_child(2)
@onready var growthTeller = get_child(0).get_child(0)

var plant_use = false
var toolbar_use = false

func _process(_delta: float) -> void:
	if !plant_use and !toolbar_use:
		visible = false
	
func deactivate(user : String):
	if user == "plants":
		plant_use = false
	else:
		toolbar_use = false

func inventory(givenName : String):
	toolbar_use = true
	
	stageTeller.visible = false
	timeTeller.visible = false
	sellTeller.visible = true
	priceTeller.visible = true
	growthTeller.visible = true

	global_position = get_global_mouse_position() + Vector2(-40, -150)
	visible = true
	nameTeller.text = givenName
	
	if (plants.plant_info.get(givenName)):
		sellTeller.text = "Sells for " + str(plants.plant_info[givenName]["sell"])
		priceTeller.text = "Buy for " + str(plants.plant_info[givenName]["price"])
		var time_to_grow = plants.plant_info[givenName]["stage1"]["sec"] + plants.plant_info[givenName]["stage2"]["sec"] + plants.plant_info[givenName]["stage3"]["sec"]
		growthTeller.text = "Takes " + str(time_to_grow) + " seconds to grow"

		var seasons = ""
		
		for found_season in plants.plant_info[givenName]["seasons"]:
			if seasons == "":
				seasons += found_season
			else:
				seasons += ", " + found_season
			
		seasonTeller.text = seasons
	else:
		var time_to_grow = plants.tree_info[givenName]["stage1"]["sec"] + plants.tree_info[givenName]["stage2"]["sec"] + plants.tree_info[givenName]["stage3"]["sec"]
		var time_to_harvest = plants.tree_info[givenName]["stage4"]["sec"]
		growthTeller.text = "Reach stage 4 in " + str(time_to_grow) + " seconds and harvest after " + str(time_to_harvest) + " seconds."
		sellTeller.text = "Each harvest sells for " + str(plants.tree_info[givenName]["sell"])
		priceTeller.text = "Buy for " + str(plants.tree_info[givenName]["price"])
		var seasons = ""
		
		for found_season in plants.tree_info[givenName]["seasons"]:
			if seasons == "":
				seasons += found_season
			else:
				seasons += ", " + found_season
			
		seasonTeller.text = seasons
				
func display(stage : String, type : String, givenName : String, time : String) -> void:
	plant_use = true
	
	stageTeller.visible = true
	timeTeller.visible = true
	sellTeller.visible = false
	priceTeller.visible = false
	growthTeller.visible = false
	
	global_position = get_global_mouse_position() + Vector2(-40, -150)
	visible = true
	nameTeller.text = givenName	
	
	if type == "crop":
		stageTeller.text = "Stage " + stage + " / 4"
		
		if plants.tree_info.has(givenName):
			if plants.tree_info[givenName]["seasons"].has(SeasonVariables.season.name):
				seasonTeller.text = "In season"
			else:
				seasonTeller.text = "Out of season"
		else:
			if plants.plant_info[givenName]["seasons"].has(SeasonVariables.season.name):
				seasonTeller.text = "In season"
			else:
				seasonTeller.text = "Out of season"
		
		if stage == "4":
			timeTeller.text = "Ready to harvest"
		else:
			timeTeller.text = "Time until next stage: " + time
	else:
		stageTeller.text = "Stage " + stage + " / 5"
		
		if stage == "5":
			timeTeller.text = "Ready to harvest"
		else:
			timeTeller.text = "Time until next stage: " + time
	
