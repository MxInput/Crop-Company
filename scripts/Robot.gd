extends CharacterBody2D

var grid : AStarGrid2D

var current_cell : Vector2i
var target_cell : Vector2i
var move_points : Array

var finished : bool = true
var moving : bool = false
var current_point : int = 0

var SPEED : float = 50.0

@onready var animated_sprite = get_child(1)

@onready var tiles: TileMapLayer = get_node("/root/Game/Terrain")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var watered: TileMapLayer = get_node("/root/Game/Watered")

@onready var paths_node: Node2D = get_node("/root/Game/Paths")

var astar_grid = AStarGrid2D.new()

func initialize(_grid : AStarGrid2D, _target : Vector2i):
	grid = _grid
	moving = false
	current_cell = tiles.local_to_map(tiles.to_local(global_position))
	target_cell = _target
	finished = false
	
func _process(delta: float) -> void:
	if !plants.plant_data.get(target_cell) or tiles.watered_tiles.get(target_cell):
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

func _physics_process(delta: float) -> void:
	if !move_points.is_empty():
		if current_point == move_points.size() - 2:
			velocity = Vector2.ZERO
			global_position = move_points[-2]
			current_cell = tiles.local_to_map(tiles.to_local(global_position))
			if (plants.tree_info.get(plants.plant_data[target_cell]["fruit_name"])):
				if !tiles.watered_tiles.get(target_cell):
					if plants.plant_data.get(target_cell):
						for x in 3:
							for y in 4:						
								paths_node.targeted.erase(target_cell)
								
								tiles.watered_tiles[target_cell + Vector2i(x-1, y-2)] = {"time": 0}
								watered.set_cell(target_cell + Vector2i(x-1, y-2), 0, Vector2i.ZERO)
			else:
				paths_node.targeted.erase(target_cell)
				if !tiles.watered_tiles.get(target_cell):
					if plants.plant_data.get(target_cell):
						tiles.watered_tiles[target_cell] = {"time": 0}
						watered.set_cell(target_cell, 0, Vector2i(0,0))
			moving = false
			finished = true
			move_points.clear()
			current_point = 0
			target_cell = Vector2i.ZERO
		else:
			var dir = (move_points[current_point + 1] - global_position).normalized()

			var sides = [Vector2.from_angle(PI/4), Vector2.from_angle(3 * PI/4), Vector2.from_angle(5 * PI/4), Vector2.from_angle(7 * PI/4)]
		
			match dir:
				Vector2.UP:
					animated_sprite.play("back")
				Vector2.DOWN:
					animated_sprite.play("front")
				Vector2.LEFT:
					animated_sprite.play("left")
				Vector2.RIGHT:
					animated_sprite.play("right")
					
			if (dir - sides[0]).length() < 0.01 or (dir - sides[3]).length() < 0.01:
				animated_sprite.play("right")
			elif (dir - sides[1]).length() < 0.01 or (dir - sides[2]).length() < 0.01:
				animated_sprite.play("left")
				
			velocity = dir * SPEED
			move_and_slide()
			
			if (move_points[current_point + 1] - global_position).length() < 4:
				current_cell = tiles.local_to_map(tiles.to_local(global_position))
				current_point += 1
	else:
		if current_cell == target_cell || tiles.get_surrounding_cells(current_cell).has(target_cell):
			velocity = Vector2.ZERO
			if (plants.plant_data.has(target_cell)):
				if (plants.tree_info.get(plants.plant_data[target_cell]["fruit_name"])):
					if !tiles.watered_tiles.get(target_cell):	
						for x in 3:
							for y in 4:						
								paths_node.targeted.erase(target_cell)
								
								tiles.watered_tiles[target_cell + Vector2i(x-1, y-2)] = {"time": 0}
								watered.set_cell(target_cell + Vector2i(x-1, y-2), 0, Vector2i.ZERO)
					else:
						for x in 3:
							for y in 4:
								paths_node.targeted.erase(target_cell)
				else:
					paths_node.targeted.erase(target_cell)
					
					if !tiles.watered_tiles.get(target_cell):
						if plants.plant_data.get(target_cell):
							tiles.watered_tiles[target_cell] = {"time": 0}
							watered.set_cell(target_cell, 0, Vector2i(0,0))
				moving = false
				finished = true
				current_point = 0
				target_cell = Vector2i.ZERO
			else:
				paths_node.targeted.erase(target_cell)
			
			
