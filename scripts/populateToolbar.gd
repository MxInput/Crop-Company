extends Control

@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var container = get_child(0).get_child(0)

var hovered_on : String = ""
var dragging : String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var temp_fruit = preload("res://nodes/Icon.tscn")
	
	var plant_info = plants.plant_info
	
	for plant in plant_info:
		var new_fruit = temp_fruit.instantiate()
		new_fruit.name = plant
		new_fruit.get_child(0).texture = plant_info[plant]["icon"]
		container.add_child(new_fruit)
	pass # Replace with function body.
