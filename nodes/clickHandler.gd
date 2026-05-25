extends TileMapLayer

@onready var select: Node2D = get_node("Select")

func  _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		var mouse_pos = get_local_mouse_position()
		var cell_pos = local_to_map(mouse_pos)
		var tile_id = (get_cell_source_id(cell_pos))
		if (tile_id == 0):
			set_cell(cell_pos, 1, Vector2i(0, 0))
		
func _process(delta: float):
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	highlight(cell_pos)
		
func highlight (cell_pos: Vector2i):
	select.position = map_to_local(cell_pos)
