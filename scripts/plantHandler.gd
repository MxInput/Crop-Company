extends TileMapLayer

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")

var plant_info = {
	"Watermelon": {
		"stage1": { "sec": 10, "tile_id": 3},
		"stage2": { "sec": 20, "tile_id": 2},
		"stage3": { "sec": 30, "tile_id": 0},
		"stage4": {"tile_id": 1},
		"icon": load("res://tiles/toolbar/fruits/watermelon_icon.png")
	},
	"Carrot": {
		"stage1": { "sec": 30, "tile_id": 7},
		"stage2": { "sec": 40, "tile_id": 6},
		"stage3": { "sec": 50, "tile_id": 4},
		"stage4": {"tile_id": 5},
		"icon": load("res://tiles/toolbar/fruits/carrot_icon.png")
	},
	"Pumpkin": {
		"stage1": { "sec": 30, "tile_id": 11},
		"stage2": { "sec": 40, "tile_id": 8},
		"stage3": { "sec": 50, "tile_id": 9},
		"stage4": {"tile_id": 10},
		"icon": load("res://tiles/toolbar/fruits/pumpkin_icon.png")
	}
}
var plant_data = {}
	
func plant(plant_name) -> void:
	var local_pos = terrain.to_local(get_global_mouse_position())
	var cell_pos = terrain.local_to_map(local_pos)
	var tile_id = (terrain.get_cell_source_id(cell_pos))
	if (tile_id == 1):
		plant_data[cell_pos] = { "fruit_name" : plant_name, "stage" : 1, "time" : 0}
		set_cell(cell_pos, plant_info[plant_name]["stage1"]["tile_id"], Vector2i(0, 0))
		
func _process(delta: float) -> void:
	for plant in plant_data:
		var stage = plant_data[plant]["stage"]
		var time = plant_data[plant]["time"]
		time += delta
		plant_data[plant]["time"] = time
	
