extends CharacterBody2D

@onready var tiles: TileMapLayer = get_node("/root/Game/Terrain")

var tiles_per_second: float = 1.0
var prev_pos : Vector2 = Vector2.ZERO

var remaining_move_ticks: int = 0

var physics_ticks_per_move: int = 0

var physics_velocity_fraction: float = 0.0

var target 

func _ready() -> void:
	prev_pos = global_position
	
	physics_ticks_per_move = roundi(Engine.physics_ticks_per_second / tiles_per_second)
	
	physics_velocity_fraction = Engine.physics_ticks_per_second / float(physics_ticks_per_move)
	
func _physics_process(delta: float) -> void:
	if remaining_move_ticks == 0:
		var direction : Vector2 = (target.position-position).normalized()
		
		var pos_tiles: Vector2 = tiles.to_local(global_position)
		var map_pos: Vector2i = tiles.local_to_map(pos_tiles)

		var map_direction: Vector2i = dir_to_map(direction)
		if map_direction.x == 0 and map_direction.y == 0:
			velocity = Vector2.ZERO
		else:
			var next_map_pos: Vector2i = map_pos + map_direction
			if is_walkable(next_map_pos):
				var next_map_local_pos: Vector2 = tiles.map_to_local(next_map_pos)
				var next_global_pos: Vector2 = tiles.to_global(next_map_local_pos)
				velocity = (next_global_pos - global_position) * physics_velocity_fraction
				remaining_move_ticks = physics_ticks_per_move
			else:
				velocity = Vector2.ZERO

		prev_pos = global_position
		if remaining_move_ticks > 0:
			move_and_slide()
			remaining_move_ticks -= 1
		
func dir_to_map(given_dir : Vector2) -> Vector2i:
	if is_equal_approx(abs(given_dir.x), abs(given_dir.y)):
		return Vector2.ZERO
	elif abs(given_dir.x) > abs(given_dir.y):
		return Vector2(roundf(given_dir.x), 0)
	else:
		return Vector2(0, roundf(given_dir.y))
	
func is_walkable(given_map_pos : Vector2i) -> bool:
	var tile_data: TileData = tiles.get_cell_tile_data(given_map_pos)
	if not tile_data:
		return false

	return tile_data.get_collision_polygons_count(0) < 1
