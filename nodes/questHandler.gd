extends Node2D

var quest_temp = preload("res://nodes/questTemplate.tscn")

@onready var quest_menu = get_node("/root/Game/CanvasLayer/QuestMenu")

var quests = {
	"Harvest 10 Carrots": {
		"Status": "In Progress",
		"Reward": "Unlock Cabbages",
		"Amount": 0
	},
	"Reach Summer": {
		"Status": "In Progress",
		"Reward": "Unlock Watermelon",
		"Amount": 0
	}
}

func _ready() -> void:
	for quest in quests:
		var quest_created = quest_temp.instantiate()
		quest_menu.get_child(0).get_child(0).add_child(quest_created)
		
		quest_created.get_child(1).text = quests[quest]["Status"]
		quest_created.get_child(2).text = "Reward - " + quests[quest]["Reward"]
		quest_created.get_child(3).text = quest
		quest_created.name = quest
