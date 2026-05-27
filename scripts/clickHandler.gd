extends TileMapLayer

@onready var select: Node2D = get_node("Select")

var watered_tiles = {}

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
	elif ToolVariables.current_tool == "WateringCan":
		if event.is_action_pressed("click"):
			var mouse_pos = get_local_mouse_position()
			var cell_pos = local_to_map(mouse_pos)
			var tile_id = (get_cell_source_id(cell_pos))
			if (tile_id == 1):
				watered_tiles[cell_pos] = {"time": 0}
				set_cell(cell_pos, 2, Vector2i(0, 0))
				
func _process(delta: float):
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	highlight(cell_pos)
	
	for watered_tile in watered_tiles:
		watered_tiles[watered_tile]["time"] += delta
		if watered_tiles[watered_tile]["time"] >= 60:
			watered_tiles.erase(watered_tile)
			set_cell(watered_tile, 1, Vector2i(0, 0))
		
func highlight (cell_pos: Vector2i):
	select.position = map_to_local(cell_pos)
