extends TileMapLayer

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")

var plant_data = {}

func plant() -> void:
	var local_pos = terrain.to_local(get_global_mouse_position())
	var cell_pos = terrain.local_to_map(local_pos)
	var tile_id = (terrain.get_cell_source_id(cell_pos))
	if (tile_id == 1):
		plant_data[cell_pos] = { "fruit_name" : "watermelon", "stage" : 1, "time" : 0}
		set_cell(cell_pos, 1, Vector2i(0, 0))
		
func _process(delta: float) -> void:
	for plant in plant_data:
		var stage = plant_data[plant]["stage"]
		var time = plant_data[plant]["time"]
		time += delta
		plant_data[plant]["time"] = time
		print(time)
	
