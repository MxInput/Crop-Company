extends OptionButton

@onready var game = get_node("/root/Game")
@onready var camera = get_node("/root/Game/Camera2D")
@onready var plants = get_node("/root/Game/Plants")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

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

func _on_item_selected(index: int) -> void:
	if robots[robots.keys()[index-1]]["Amount"] < robots[robots.keys()[index-1]]["Max"]:
		if PlayerVariables.player.buy(robots[robots.keys()[index-1]]["Price"]):
			var pos = get_viewport_rect().size / 2.0 + Vector2(camera.position.x, camera.position.y)
			var cell_pos = plants.to_local(pos)
			print(pos, cell_pos)
			var new_bot = robots[robots.keys()[index-1]]["Asset"].instantiate()
			game.add_child(new_bot)
			new_bot.position = Vector2(16, 16)
			robots[robots.keys()[index-1]]["Amount"] += 1
			coin_display.new_instance(-robots[robots.keys()[index-1]]["Price"])
		else:
			coin_display.tell_warning("Not enough coins")
	else:
		coin_display.tell_warning("Max amount of this robot")

	selected = 0
