extends CharacterBody2D

var grid : AStarGrid2D

var current_cell : Vector2i
var target_cell : Vector2i
var move_points : Array

var finished : bool = true
var moving : bool = false
var current_point : int = 0

@onready var upgrades : Node2D = get_node("/root/Game/Upgrades")

@onready var SPEED : float = upgrades.upgrades["Rapid Robots"]["Speeds"][upgrades.upgrades["Rapid Robots"]["Level"]-1]

@onready var animated_sprite = get_child(1)

@onready var tiles: TileMapLayer = get_node("/root/Game/Terrain")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")

@onready var paths_node: Node2D = get_node("/root/Game/Paths")

@onready var coin_display : Node = get_node("/root/Game/CoinDisplay")

var astar_grid = AStarGrid2D.new()

func initialize(_grid : AStarGrid2D, _target : Vector2i):
	grid = _grid
	moving = false
	current_cell = tiles.local_to_map(tiles.to_local(global_position))
	target_cell = _target
	finished = false
	
func _process(_delta: float) -> void:
	if !plants.plant_data.has(target_cell) or plants.plant_data[target_cell]["stage"] < 4:
		velocity = Vector2.ZERO
		current_cell = tiles.local_to_map(tiles.to_local(global_position))
		moving = false
		finished = true
		move_points.clear()
		current_point = 0
		target_cell = Vector2i.ZERO
			
	if !finished:
		if current_cell != target_cell:
			if !moving:
				move_points = grid.get_point_path(current_cell, target_cell)
				move_points = (move_points as Array).map(func (p): return p + grid.cell_size/2.0)
				start_moving()
		else:
			finished = true

func start_moving():
	if move_points.is_empty(): return
	current_point = 0; moving = true

func _physics_process(_delta: float) -> void:
	if !move_points.is_empty():
		if current_point == move_points.size() - 2:
			velocity = Vector2.ZERO
			global_position = move_points[-2]
			current_cell = tiles.local_to_map(tiles.to_local(global_position))
			if (plants.tree_info.has(plants.plant_data[target_cell]["fruit_name"])):
				if plants.plant_data.has(target_cell):
					if plants.plant_data[target_cell]["stage"] == 5:
						var rewarded = false
						for x in 3:
							for y in 4:						
								paths_node.pickup_targeted.erase(target_cell)
								
								if !rewarded:
									rewarded = true
									PlayerVariables.player.sell(plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])
									coin_display.new_instance(plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])
								plants.plant_data[plants.plant_data[target_cell]["initial"] + Vector2i(x-1, y-2)]["stage"] -= 1
								plants.set_cell(plants.plant_data[target_cell]["initial"] + Vector2i(x-1, y-2), plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["stage4"]["tile_id"], Vector2i(x, y))	
			else:					
				paths_node.pickup_targeted.erase(target_cell)
				if plants.plant_data.has(target_cell):
					if plants.plant_data[target_cell]["stage"] == 4:
						PlayerVariables.player.sell(plants.plant_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])
						coin_display.new_instance(plants.plant_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])	
						
						plants.plant_data.erase(target_cell)
						plants.erase_cell(target_cell)
						tiles.set_cell(target_cell, 0, Vector2i(0,0))
			moving = false
			finished = true
			move_points.clear()
			current_point = 0
			target_cell = Vector2i.ZERO
		else:
			var dir = (move_points[current_point + 1] - global_position).normalized()
			
			if not dir.is_zero_approx():
				var angle = dir.angle()
				var offset = angle / (PI/4)
				var index = wrapi(int(offset), 0, 8)
				
				if index == 0 or index == 7 or index == 1:
					animated_sprite.play("right")
				if index == 2 :
					animated_sprite.play("front")		
				if index == 4 or index == 3 or index == 5:
					animated_sprite.play("left")
				if index == 6:
					animated_sprite.play("back")
				
			velocity = dir * SPEED
			move_and_slide()
			
			if (move_points[current_point + 1] - global_position).length() < 4:
				current_cell = tiles.local_to_map(tiles.to_local(global_position))
				current_point += 1
	else:
		if current_cell == target_cell || tiles.get_surrounding_cells(current_cell).has(target_cell):
			velocity = Vector2.ZERO
			if (plants.plant_data.has(target_cell)):
				if (plants.tree_info.has(plants.plant_data[target_cell]["fruit_name"])):
					if plants.plant_data[target_cell]["stage"] == 5:	
						var rewarded = false
						for x in 3:
							for y in 4:						
								paths_node.pickup_targeted.erase(target_cell)
								
								if !rewarded:
									rewarded = true
									PlayerVariables.player.sell(plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])
									coin_display.new_instance(plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])	
								plants.plant_data[plants.plant_data[target_cell]["initial"] + Vector2i(x-1, y-2)]["stage"] -= 1
								plants.set_cell(plants.plant_data[target_cell]["initial"] + Vector2i(x-1, y-2), plants.tree_info[plants.plant_data[target_cell]["fruit_name"]]["stage4"]["tile_id"], Vector2i(x, y))	
					else:
						paths_node.pickup_targeted.erase(target_cell)
				else:
					paths_node.pickup_targeted.erase(target_cell)
					
					if plants.plant_data[target_cell]["stage"] == 4:	
						PlayerVariables.player.sell(plants.plant_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])
						coin_display.new_instance(plants.plant_info[plants.plant_data[target_cell]["fruit_name"]]["sell"])	
						
						plants.plant_data.erase(target_cell)
						plants.erase_cell(target_cell)
						tiles.set_cell(target_cell, 0, Vector2i(0,0))

				moving = false
				finished = true
				current_point = 0
				target_cell = Vector2i.ZERO
			else:
				paths_node.pickup_targeted.erase(target_cell)
