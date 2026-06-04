extends Node2D

var quest_temp = preload("res://nodes/questTemplate.tscn")

@onready var quest_menu = get_node("/root/Game/CanvasLayer/QuestMenu")

var quests = {
	"Harvest 80 Crops": {
		"Status": "In Progress",
		"Reward": "Unlock Robots",
		"Amount": 0.0,
		"Max": 80.0,
		"Type": "Count"
	},
	"Reach Summer": {
		"Status": "In Progress",
		"Reward": "Unlock Watermelon",
		"Completed": false,
		"Type": "Completion"
	},
	"Experience all seasons and make it back to Spring": {
		"Status": "In Progress",
		"Reward": "Unlock Pomegranate",
		"Completed": false,
		"Type": "Completion"
	},
	"Have 5 Banana Trees at once": {
		"Status": "In Progress",
		"Reward": "Unlock Apple Trees",
		"Amount": 0.0,
		"Max": 5.0,
		"Type": "Count"
	},
	"Harvest plants worth a total of 1000 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Grapefruit Trees",
		"Amount": 0.0,
		"Max": 1000.0,
		"Type": "Count"
	},
	"Harvest plants worth a total of 5000 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Kale",
		"Amount": 0.0,
		"Max": 5000.0,
		"Type": "Count"
	},
	"Buy a robot": {
		"Status": "In Progress",
		"Reward": "Unlock Pumpkin",
		"Completed": false,
		"Type": "Completion"
	},
	"Have (at least) one of each robot type": {
		"Status": "In Progress",
		"Reward": "Unlock Butternut Squash",
		"Completed": false,
		"Type": "Completion"
	},
	"Buy an upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Coconut",
		"Completed": false,
		"Type": "Completion"
	},
	"Buy every upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Potato",
		"Completed": false,
		"Type": "Completion"
	},
	"Spend 1000 Coins": {
		"Status": "In Progress",
		"Reward": "Unlock Tomato",
		"Completed": false,
		"Type": "Completion"
	},
	"Complete the Tutorial (or skip it)": {
		"Status": "In Progress",
		"Reward": "Unlock Beet, Fig, and Cabbage",
		"Completed": true,
		"Type": "Completion"
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
