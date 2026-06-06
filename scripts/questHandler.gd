extends Node2D

var quest_temp = preload("res://nodes/questTemplate.tscn")

@onready var quest_menu = get_node("/root/Game/CanvasLayer/QuestMenu")
	
var quests = {
	"Harvest 100 Crops": {
		"Status": "In Progress",
		"Reward": "Unlock Robots",
		"Reward Array": ["Robots"],
		"Amount": 0.0,
		"Max": 100.0,
		"Took": false,
		"Type": "Count"
	},
	"Reach Summer": {
		"Status": "In Progress",
		"Reward": "Unlock Watermelon",
		"Reward Array": ["Watermelon"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Experience all seasons and make it back to Spring": {
		"Status": "In Progress",
		"Reward": "Unlock Pomegranate",
		"Reward Array": ["Pomegranate"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Have 5 Banana Trees at once": {
		"Status": "In Progress",
		"Reward": "Unlock Apple Trees",
		"Reward Array": ["Apple"],
		"Amount": 0.0,
		"Max": 5.0,
		"Took": false,
		"Type": "Count"
	},
	"Harvest plants worth a total of 1400 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Grapefruit Trees",
		"Reward Array": ["Grapefruit"],
		"Amount": 0.0,
		"Max": 1400.0,
		"Took": false,
		"Type": "Count"
	},
	"Harvest plants worth a total of 5600 coins": {
		"Status": "In Progress",
		"Reward": "Unlock Kale",
		"Reward Array": ["Kale"],
		"Amount": 0.0,
		"Max": 5600.0,
		"Took": false,
		"Type": "Count"
	},
	"Buy a robot": {
		"Status": "In Progress",
		"Reward": "Unlock Pumpkin",
		"Reward Array": ["Pumpkin"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Have (at least) one of each robot type": {
		"Status": "In Progress",
		"Reward": "Unlock Butternut Squash",
		"Reward Array": ["Butternut Squash"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Buy an upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Coconut",
		"Reward Array": ["Coconut"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Buy every upgrade": {
		"Status": "In Progress",
		"Reward": "Unlock Potato",
		"Reward Array": ["Potato"],
		"Completed": false,
		"Took": false,
		"Type": "Completion"
	},
	"Complete 5 quests": {
		"Status": "In Progress",
		"Reward": "Unlock Tomato",
		"Reward Array": ["Tomato"],
		"Amount": 0.0,
		"Max": 5.0,
		"Took": false,
		"Type": "Count"
	},
	"Complete 10 quests": {
		"Status": "In Progress",
		"Reward": "Unlock Raddish",
		"Reward Array": ["Raddish"],
		"Amount": 0.0,
		"Max": 10.0,
		"Took": false,
		"Type": "Count"
	},
	"Complete the Tutorial (or skip it)": {
		"Status": "In Progress",
		"Reward": "Unlock Beet, Fig, and Cabbage",
		"Reward Array": ["Beet", "Fig", "Cabbage"],
		"Completed": false,
		"Took": false,
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
