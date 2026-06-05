extends Control

@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var container = get_child(0).get_child(0)

func unlock_plant(plant_names):	
	for plant in plant_names:
		var found_plant = get_child(0).get_child(0).get_node(NodePath(plant))
		found_plant.get_child(2).visible = false
		if plants.plant_info.has(plant):
			plants.plant_info[plant]["locked"] = false
		else:
			plants.tree_info[plant]["locked"] = false

func _ready() -> void:
	var temp_fruit = preload("res://nodes/Icon.tscn")
	
	var plant_info = plants.plant_info
	var tree_info = plants.tree_info
	
	for plant in plant_info:
		var new_fruit = temp_fruit.instantiate()
		new_fruit.name = plant
		new_fruit.get_child(0).texture = plant_info[plant]["icon"]
		container.add_child(new_fruit)
		
		if plant_info[plant]["locked"]:
			new_fruit.get_child(2).visible = true
		
	for tree in tree_info:
		var new_tree = temp_fruit.instantiate()
		new_tree.name = tree
		new_tree.texture = load("res://tiles/toolbar/tree_bar.png")
		new_tree.get_child(0).texture = tree_info[tree]["icon"]
		container.add_child(new_tree)
		
		if tree_info[tree]["locked"]:
			new_tree.get_child(2).visible = true
