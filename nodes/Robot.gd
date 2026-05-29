extends CharacterBody2D

var grid : AStarGrid2D

var current_cell : Vector2i
var target_cell : Vector2i
var move_points : Array

var finished : bool = true
var moving : bool = false
var current_point : int = 0

var SPEED : float = 50.0

@onready var tiles: TileMapLayer = get_node("/root/Game/Terrain")

var astar_grid = AStarGrid2D.new()

func initialize(_grid : AStarGrid2D, _target : Vector2i):
	grid = _grid
	moving = false
	current_cell = global_position / grid.cell_size
	target_cell = _target
	finished = false
	
func _process(delta: float) -> void:
	if !finished:
		if current_cell != target_cell:
			if !moving:
				move_points = grid.get_point_path(current_cell, target_cell)
				start_moving()
		else:
			finished = true

func start_moving():
	if move_points.is_empty(): return
	current_point = 0; moving = true
	
func _physics_process(delta: float) -> void:
	if !move_points.is_empty():
		if current_point == move_points.size() - 1:
			velocity = Vector2.ZERO
			global_position = move_points[-1]
			current_cell = global_position / grid.cell_size
			moving = false
			finished = true
		else:
			var dir = (move_points[current_point + 1] - move_points[current_point]).normalized()
			velocity = dir * SPEED
			move_and_slide()
			if (move_points[current_point + 1] - global_position).length() < 4:
				current_cell = global_position / grid.cell_size
				current_point += 1
		
