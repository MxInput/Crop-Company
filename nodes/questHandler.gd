extends Node2D

var quest_temp = preload("res://nodes/questTemplate.tscn")

@onready var quest_menu = get_node("/root/Game/CanvasLayer/QuestMenu")

var quests = {
	"Harvest 80 Crops": {
		"Status": "In Progress",
		"Reward": "Unlock Robots",
		"Amount": 0,
		"Max": 80,
		"Type": "Count"
	},
	"Reach Summer": {
		"Status": "In Progress",
		"Reward": "Unlock Watermelon",
		"Completed": false
	},
	"Experience all seasons and make it back to Spring": {
		"Status": "In Progress",
		"Reward": "Unlock Pomegranate",
		"Completed": false
	},
	"Plant 5 Banana Trees": {
		"Status": "In Progress",
		"Reward": "Unlock Apple Trees",
		"Amount": 0
	},
	"Earn 1000 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Grapefruit Trees",
		"Amount": 0
	},
	"Earn 5000 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Kale",
		"Amount": 0
	},
	"Buy a robot": {
		"Status": "In Progress",
		"Reward": "Unlock Pumpkin",
		"Amount": 0
	},
	"Have (at least) one of each robot type": {
		"Status": "In Progress",
		"Reward": "Unlock Butternut Squash",
		"Amount": 0
	},
	"Buy an upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Coconut",
		"Amount": 0
	},
	"Buy every upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Potato",
		"Amount": 0
	},
	"Spend 1000 Coins": {
		"Status": "In Progress",
		"Reward": "Unlock Tomato",
		"Amount": 0
	},
	"Complete the Tutorial (or skip it)": {
		"Status": "In Progress",
		"Reward": "Unlock Beet, Fig, and Cabbage",
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
