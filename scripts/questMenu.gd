extends TextureRect

@onready var quests = get_node("/root/Game/Quests")

@onready var plants: TileMapLayer = get_node("/root/Game/Plants")

func get_quests_completed() -> int:
	var quest_info = quests.quests
	
	var count = 0 
	for quest in quest_info:
		if quest_info[quest]["Type"] == "Count":
			if quest_info[quest]["Amount"] / quest_info[quest]["Max"] >= 1:
				count += 1
		else:
			if quest_info[quest]["Completed"]:
				count += 1
	return count
	
func update_value(current_button):
	var quest_info = quests.quests
	
	if quest_info[current_button.name]["Type"] == "Count":
		if quest_info[current_button.name]["Amount"] / quest_info[current_button.name]["Max"] >= 1:
			current_button.get_child(0).value = 100
			current_button.get_child(1).text = "Completed"
		else:
			current_button.get_child(0).value = quest_info[current_button.name]["Amount"] / quest_info[current_button.name]["Max"] * 100
	elif quest_info[current_button.name]["Completed"]:
		current_button.get_child(0).value = 100
		current_button.get_child(1).text = "Completed"
	
func _on_quest_button_pressed() -> void:
	if quests.quests["Complete 5 quests"]["Amount"] < quests.quests["Complete 5 quests"]["Max"]:
		quests.quests["Complete 5 quests"]["Amount"] = get_quests_completed()
		
	if quests.quests["Complete 10 quests"]["Amount"] < quests.quests["Complete 10 quests"]["Max"]:
		quests.quests["Complete 10 quests"]["Amount"] = get_quests_completed()
		
	for found_quest in get_child(0).get_child(0).get_children():
		update_value(found_quest)
		
