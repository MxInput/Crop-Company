extends Control

@onready var plants : TileMapLayer = get_node("/root/Game/Plants")

@onready var stageTeller = get_child(0).get_child(2)
@onready var nameTeller = get_child(0).get_child(3)
@onready var timeTeller = get_child(0).get_child(4)

@onready var sellTeller = get_child(0).get_child(0)
@onready var priceTeller = get_child(0).get_child(1)

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

	global_position = get_global_mouse_position() + Vector2(-40, -150)
	visible = true
	nameTeller.text = givenName
	nameTeller.get_child(0).text = nameTeller.text
	
	if (plants.plant_info.get(givenName)):
		sellTeller.text = "Sells for " + str(plants.plant_info[givenName]["sell"])
		priceTeller.text = "Buy for " + str(plants.plant_info[givenName]["price"])
	else:
		sellTeller.text = "Sells for " + str(plants.tree_info[givenName]["sell"])
		priceTeller.text = "Buy for " + str(plants.tree_info[givenName]["sell"])
	sellTeller.get_child(0).text = sellTeller.text
	priceTeller.get_child(0).text = priceTeller.text
	
func display(stage : String, type : String, givenName : String, time : String) -> void:
	plant_use = true
	
	stageTeller.visible = true
	timeTeller.visible = true
	sellTeller.visible = false
	priceTeller.visible = false
	
	global_position = get_global_mouse_position() + Vector2(-40, -150)
	visible = true
	nameTeller.text = givenName
	nameTeller.get_child(0).text = nameTeller.text
	if type == "crop":
		stageTeller.text = "Stage " + stage + " / 4"
		
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
	stageTeller.get_child(0).text = stageTeller.text
	timeTeller.get_child(0).text = timeTeller.text
	
