extends TextureRect

@onready var quests = get_node("/root/Game/Quests")
@onready var quest_info = quests.quests

func update_value(current_button):
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
	for found_quest in get_child(0).get_child(0).get_children():
		update_value(found_quest)
		
