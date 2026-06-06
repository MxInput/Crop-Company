extends OptionButton

@onready var game = get_node("/root/Game")
@onready var camera = get_node("/root/Game/Camera2D")
@onready var plants = get_node("/root/Game/Plants")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

signal new_bot_purchased

@onready var quests = get_node("/root/Game/Quests")

func save():
	var save_dict = {
		"water_bots": get_tree().get_nodes_in_group("Water_Robots").size(),
		"fertillBots": get_tree().get_nodes_in_group("fertillBots"),
		"pestBots": get_tree().get_nodes_in_group("pestBot"),
		"pickupBots": get_tree().get_nodes_in_group("pickupBot").size()
	}
	return save_dict
	
var robots = {
	"Water": {
		"Price": 50,
		"Amount": 0,
		"Asset": preload("res://nodes/Robot.tscn"),
		"Max": 5
	},
	"Fertilize": {
		"Price": 25,
		"Amount": 0,
		"Asset": preload("res://nodes/FertilizeBot.tscn"),
		"Max": 5
	},
	"Pest": {
		"Price": 100,
		"Amount": 0,
		"Asset": preload("res://nodes/PestBot.tscn"),
		"Max": 5
	},
	"Pickup": {
		"Price": 75,
		"Amount": 0,
		"Asset": preload("res://nodes/PickupBot.tscn"),
		"Max": 5
	}
}

func bought_all() -> bool:
	if get_tree().get_nodes_in_group("Water_Robots").size() > 0 && get_tree().get_nodes_in_group("fertillBots").size() > 0 && get_tree().get_nodes_in_group("pestBot").size() > 0 && get_tree().get_nodes_in_group("pickupBot").size() > 0:
		return true
	return false
	
func _ready() -> void:
	set_item_text(1, get_item_text(1) + " - " + str(robots[robots.keys()[0]]["Price"]))
	set_item_text(2, get_item_text(2) + " - " + str(robots[robots.keys()[1]]["Price"]))
	set_item_text(3, get_item_text(3) + " - " + str(robots[robots.keys()[2]]["Price"]))
	set_item_text(4, get_item_text(4) + " - " + str(robots[robots.keys()[3]]["Price"]))
	
func _on_item_selected(index: int) -> void:
	if robots[robots.keys()[index-1]]["Amount"] < robots[robots.keys()[index-1]]["Max"]:
		if PlayerVariables.player.buy(robots[robots.keys()[index-1]]["Price"]):
			var pos = camera.position

			var cell_pos = plants.local_to_map(pos)
			
			var new_bot = robots[robots.keys()[index-1]]["Asset"].instantiate()
			game.add_child(new_bot)
			new_bot.position = plants.to_global(plants.map_to_local(cell_pos))
			
			if !quests.quests["Buy a robot"]["Completed"]:
				quests.quests["Buy a robot"]["Completed"] = true
				
			if !quests.quests["Have (at least) one of each robot type"]["Completed"]:
				if bought_all():
					quests.quests["Have (at least) one of each robot type"]["Completed"] = true
				
			robots[robots.keys()[index-1]]["Amount"] += 1
			
			new_bot_purchased.emit(robots.keys()[index-1])
			
			coin_display.new_instance(-robots[robots.keys()[index-1]]["Price"])
		else:
			coin_display.tell_warning("Not enough coins")
	else:
		coin_display.tell_warning("Max amount of this robot")

	selected = 0
