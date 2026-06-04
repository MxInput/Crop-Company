extends Node2D

var upgrade_temp = preload("res://nodes/upgradeTemplate.tscn")

@onready var upgrade_menu = get_node("/root/Game/CanvasLayer/UpgradesMenu")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

var max_level = 3
var upgrades = {
	"Better Fertilized": {
		"Description": "Removes a greater percentage of time from the plant when fertilizer is used.",
		"Level": 1,
		"Percentages": [0.25, 0.375, 0.5],
		"Prices": [10, 50, 100]
	},
	"Greater Soakage": {
		"Description": "Increases the length that tiles remain watered.",
		"Level": 1,
		"Times": [30, 60, 120],
		"Prices": [10, 50, 100]
	},
	"Rapid Robots": {
		"Description": "Increases the movement speed of robots.",
		"Level": 1,
		"Speeds": [10.0, 50.0, 65.0],
		"Prices": [10, 50, 100]
	},
	"Bye-Bye Pests": {
		"Description": "Decreases the rate that pests spawn at.",
		"Level": 1,
		"Rates": [90000, 92500, 95000],
		"Prices": [10, 50, 100]
	}
}

func bought(upgrade_button, chosen_upgrade):
	if upgrades[chosen_upgrade]["Level"] < max_level:
		if PlayerVariables.player.buy(upgrades[chosen_upgrade]["Prices"][upgrades[chosen_upgrade]["Level"]]):
			coin_display.new_instance(-upgrades[chosen_upgrade]["Prices"][upgrades[chosen_upgrade]["Level"]])
			upgrades[chosen_upgrade]["Level"] += 1
			upgrade_button.get_parent().get_child(1).text = "Level " + str(upgrades[chosen_upgrade]["Level"])
			if upgrades[chosen_upgrade]["Level"] < max_level:
				upgrade_button.get_parent().get_child(3).text = str(upgrades[chosen_upgrade]["Prices"][upgrades[chosen_upgrade]["Level"]]) + " coins"
			else:
				upgrade_button.get_parent().get_child(3).text = "Max Level"
			
			match chosen_upgrade:
				"Rapid Robots":
					for robot in get_tree().get_nodes_in_group("Water_Robots"):
						robot.SPEED = upgrades[chosen_upgrade]["Speeds"][upgrades[chosen_upgrade]["Level"]-1]
					for robot in get_tree().get_nodes_in_group("pestBot"):
						robot.SPEED = upgrades[chosen_upgrade]["Speeds"][upgrades[chosen_upgrade]["Level"]-1]
					for robot in get_tree().get_nodes_in_group("pickupBot"):
						robot.SPEED = upgrades[chosen_upgrade]["Speeds"][upgrades[chosen_upgrade]["Level"]-1]
					for robot in get_tree().get_nodes_in_group("fertillBots"):	
						robot.SPEED = upgrades[chosen_upgrade]["Speeds"][upgrades[chosen_upgrade]["Level"]-1]
		
			if upgrade_button.get_child(0).text == "PURCHASE":
				upgrade_button.get_child(0).text = "BOUGHT"
			
				var timer = Timer.new()
				add_child(timer)
				timer.timeout.connect(
					func exec():
						upgrade_button.change_back()
						timer.queue_free()
				)
				timer.wait_time = 3.0
				timer.one_shot = true
				timer.start()
		else:
			coin_display.tell_warning("Not enough coins")
			
func _ready() -> void:
	for upgrade in upgrades:
		var upgrade_created = upgrade_temp.instantiate()
		upgrade_menu.get_child(1).get_child(0).add_child(upgrade_created)
		
		upgrade_created.get_child(0).text = upgrades[upgrade]["Description"]
		upgrade_created.get_child(1).text = "Level " + str(upgrades[upgrade]["Level"])
		upgrade_created.get_child(2).text = upgrade
		if upgrades[upgrade]["Prices"][upgrades[upgrade]["Level"]] >= max_level:
			upgrade_created.get_child(3).text = str(upgrades[upgrade]["Prices"][upgrades[upgrade]["Level"]]) + " coins"
		else:
			upgrade_created.get_child(3).text = "Max Level"
		upgrade_created.name = upgrade
