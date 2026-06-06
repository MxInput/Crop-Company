extends TextureButton

@onready var quests = get_node("/root/Game/Quests")
@onready var buy_bot_button = get_node("/root/Game/CanvasLayer/BuyBot")

@onready var plants = get_node("/root/Game/Plants")

@onready var toolbar = get_node("/root/Game/CanvasLayer/Toolbar")	
 
func _on_pressed() -> void:
	if get_child(0).text != "Collected":
		if quests.quests[get_parent().name]["Type"] == "Count":
			if quests.quests[get_parent().name]["Amount"] / quests.quests[get_parent().name]["Max"] >= 1:
				get_child(0).text = "Collected"
				if plants.plant_info.has(quests.quests[get_parent().name]["Reward Array"][0]) or plants.tree_info.has(quests.quests[get_parent().name]["Reward Array"][0]):
					toolbar.unlock_plant(quests.quests[get_parent().name]["Reward Array"])
				elif quests.quests[get_parent().name]["Reward Array"][0] == "Robots":
					buy_bot_button.visible = true
		else:
			if quests.quests[get_parent().name]["Completed"]:
				get_child(0).text = "Collected"
				if plants.plant_info.has(quests.quests[get_parent().name]["Reward Array"][0]) or plants.tree_info.has(quests.quests[get_parent().name]["Reward Array"][0]):
					toolbar.unlock_plant(quests.quests[get_parent().name]["Reward Array"])
				elif quests.quests[get_parent().name]["Reward Array"][0] == "Robots":
					buy_bot_button.visible = true
			
