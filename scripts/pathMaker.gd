extends Node2D

@onready var map: TileMapLayer = get_node("/root/Game/Terrain")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")

@onready var robots = get_tree().get_nodes_in_group("Water_Robots")
@onready var pestBots = get_tree().get_nodes_in_group("pestBot")

var targeted = []
var pests_targeted = []

var a_star_grid : AStarGrid2D
	
func _ready() -> void:
	a_star_grid = AStarGrid2D.new()
	a_star_grid.cell_size = map.tile_set.tile_size 
	a_star_grid.region = map.get_used_rect() 
	a_star_grid.update()
	a_star_grid.diagonal_mode = AStarGrid2D.DIAGONAL_MODE_ONLY_IF_NO_OBSTACLES

func _process(_delta: float) -> void:
	for plant in plants.plant_data:	
		if !map.watered_tiles.has(plant) && targeted.find(plant) == -1:	
			for robot in robots:
				if robot.finished:
					if plants.tree_info.get(plants.plant_data[plant]["fruit_name"]):
						if !map.watered_tiles.has(plants.plant_data[plant]["initial"]):
							if targeted.find(plants.plant_data[plant]["initial"]) == -1: 
								targeted.append(plants.plant_data[plant]["initial"])
								robot.initialize(a_star_grid, plants.plant_data[plant]["initial"])
					else:
						targeted.append(plant)
						robot.initialize(a_star_grid, plant)
					break
		if map.infected_tiles.has(plant) && !pests_targeted.has(plant):
			for robot in pestBots:
				if robot.finished:
					if plants.tree_info.get(plants.plant_data[plant]["fruit_name"]):
						if pests_targeted.find(plants.plant_data[plant]["initial"]) == -1: 
							pests_targeted.append(plants.plant_data[plant]["initial"])
							robot.initialize(a_star_grid, plants.plant_data[plant]["initial"])
					else:
						pests_targeted.append(plant)
						robot.initialize(a_star_grid, plant)
					break
