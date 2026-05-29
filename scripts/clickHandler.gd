extends TileMapLayer

@onready var watered: TileMapLayer = get_node("/root/Game/Watered")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var fertilized: TileMapLayer = get_node("/root/Game/Fertilized")

@onready var select: Node2D = get_node("Select")

var watered_tiles = {}
var fertilized_tiles = {}

func  _input(event: InputEvent) -> void:
	if ToolVariables.current_tool == "Hoe":
		if event.is_action_pressed("click"):
			var mouse_pos = get_local_mouse_position()
			var cell_pos = local_to_map(mouse_pos)
			var tile_id = (get_cell_source_id(cell_pos))
			if (tile_id == 0):
				set_cell(cell_pos, 1, Vector2i(0, 0))
			elif (tile_id == 1):
				set_cell(cell_pos, 0, Vector2i(0, 0))
			elif (tile_id == 2):
				set_cell(cell_pos, 0, Vector2i(0, 0))
				watered_tiles.erase(cell_pos)
				if watered.get_cell_source_id(cell_pos) != -1:
					watered.erase_cell(cell_pos)
	elif ToolVariables.current_tool == "WateringCan":
		if event.is_action_pressed("click"):
			var mouse_pos = get_local_mouse_position()
			var cell_pos = local_to_map(mouse_pos)
			var tile_id = (get_cell_source_id(cell_pos))
			if (plants.plant_data.get(cell_pos)):
				if (plants.plant_data[cell_pos]["type"] == "tree"):
					var watered_tile = plants.plant_data[cell_pos]["initial"]
					watered_tiles[watered_tile] = {"time": 0}
				else:
					watered_tiles[cell_pos] = {"time": 0}
			elif (tile_id == 1 || tile_id == 2):
				watered_tiles[cell_pos] = {"time": 0}
				set_cell(cell_pos, 2, Vector2i(0, 0))
	elif ToolVariables.current_tool == "Shovel":
		var mouse_pos = get_local_mouse_position()
		var cell_pos = local_to_map(mouse_pos)
		var tile_id = (get_cell_source_id(cell_pos))
		if event.is_action_pressed("click"):
			if (tile_id == 2 && plants.plant_data.get(cell_pos)):
				watered_tiles.erase(cell_pos)
				if watered.get_cell_source_id(cell_pos) != -1:
					watered.erase_cell(cell_pos)
			if fertilized_tiles.get(cell_pos):
				if plants.plant_data[cell_pos]["type"] == "crop":
					fertilized.erase_cell(cell_pos)
					fertilized_tiles.erase(cell_pos)
				else:
					for x in 3:
						for y in 4:
							var initial = plants.plant_data[cell_pos]["initial"]
							
							fertilized_tiles.erase(initial + Vector2i(x-1, y-2))
							fertilized.erase_cell(initial + Vector2i(x-1, y-2))
	elif ToolVariables.current_tool == "Fertilizer":
		var mouse_pos = get_local_mouse_position()
		var cell_pos = local_to_map(mouse_pos)
		var tile_id = (get_cell_source_id(cell_pos))
		if event.is_action_pressed("click"):
			if (plants.plant_data.get(cell_pos)):
				if (!fertilized_tiles.get(cell_pos)):
					if plants.plant_data[cell_pos]["type"] == "crop":
						fertilized_tiles[cell_pos] = {"time": 0}
						fertilized.set_cell(cell_pos, 0, Vector2i(0,0))
					elif plants.plant_data[cell_pos]["type"] == "tree":
						var initial = plants.plant_data[cell_pos]["initial"]
						for x in 3:
							for y in 4:
								fertilized_tiles[initial + Vector2i(x-1, y-2)] = {"time": 0}
								fertilized.set_cell(initial + Vector2i(x-1, y-2), 0, Vector2i(0,0))
						
func _process(delta: float):
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	highlight(cell_pos)
	
	for watered_tile in watered_tiles:
		watered_tiles[watered_tile]["time"] += delta
		if watered_tiles[watered_tile]["time"] >= 60:
			if get_cell_source_id(watered_tile) == 2 || get_cell_source_id(watered_tile) == 1:
				set_cell(watered_tile, 1, Vector2i(0, 0))
			else:
				set_cell(watered_tile, 0, Vector2i(0, 0))
			if watered.get_cell_source_id(watered_tile) != -1:
				watered.erase_cell(watered_tile)
			watered_tiles.erase(watered_tile)
		
func highlight (cell_pos: Vector2i):
	select.position = map_to_local(cell_pos)
