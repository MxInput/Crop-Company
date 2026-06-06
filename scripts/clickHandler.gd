extends TileMapLayer

@onready var watered: TileMapLayer = get_node("/root/Game/Watered")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var fertilized: TileMapLayer = get_node("/root/Game/Fertilized")
@onready var infected: TileMapLayer = get_node("/root/Game/Pests")

@onready var select: Node2D = get_node("Select")
@onready var upgrades: Node2D = get_node("/root/Game/Upgrades")

@export var one_select : CompressedTexture2D
@export var nine_select : CompressedTexture2D

@onready var tutorial = get_node("/root/Game/CanvasLayer/Tutorial")
signal tiles_values

var watered_tiles = {}
var fertilized_tiles = {}
var infected_tiles = []
var timers = {}

var num_spaces = 1

var spawned_pests_tutorial = false

func _ready() -> void:
	tiles_values.connect(tutorial.change)

func change_select_to_one():
	select.get_child(0).texture = one_select

func change_select_to_nine():
	select.get_child(0).texture = nine_select

func  _input(event: InputEvent) -> void:
	if ToolVariables.current_tool == "Hoe":
		if event.is_action_pressed("scroll_up") or event.is_action_pressed("scroll_down"):				
			if HoverVariables.hovered_on == "" && HoverVariables.dragging == "":
				match num_spaces:
					1:
						num_spaces = 9
						change_select_to_nine()
					9:
						num_spaces = 1
						change_select_to_one()
					
		if event.is_action_pressed("click"):
			var mouse_pos = get_local_mouse_position()
			var cell_pos = local_to_map(mouse_pos)
			var tile_id = (get_cell_source_id(cell_pos))
			if num_spaces == 1:
				if (tile_id == 0):
					set_cell(cell_pos, 1, Vector2i(0, 0))
				elif (tile_id == 1):
					set_cell(cell_pos, 0, Vector2i(0, 0))
				elif (tile_id == 2):
					set_cell(cell_pos, 0, Vector2i(0, 0))
					watered_tiles.erase(cell_pos)
					if watered.get_cell_source_id(cell_pos) != -1:
						watered.erase_cell(cell_pos)
			else:
				var all_towed = true
				for x in 3:
					for y in 3:		
						var current = cell_pos + Vector2i(x-1, y-1)
						if (get_cell_source_id(current) == 0):
							all_towed = false
							set_cell(current, 1, Vector2i(0, 0))
				if all_towed:
					for x in 3:
						for y in 3:		
							var current = cell_pos + Vector2i(x-1, y-1)
							if (get_cell_source_id(current) == 2):
								watered_tiles.erase(current)
							set_cell(current, 0, Vector2i(0, 0))
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
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 20:
				tiles_values.emit()		
			if (tile_id == 2 && plants.plant_data.get(cell_pos)):
				watered_tiles.erase(cell_pos)
				if watered.get_cell_source_id(cell_pos) != -1:
					watered.erase_cell(cell_pos)
			if fertilized_tiles.get(cell_pos):
				if plants.plant_data[cell_pos]["type"] == "crop":
					fertilized.erase_cell(cell_pos)
					fertilized_tiles.erase(cell_pos)
					if plants.accounted_fertilized_tiles.has(cell_pos):
						plants.accounted_fertilized_tiles.erase(cell_pos)
				else:
					for x in 3:
						for y in 4:
							var initial = plants.plant_data[cell_pos]["initial"]
							
							fertilized_tiles.erase(initial + Vector2i(x-1, y-2))
							fertilized.erase_cell(initial + Vector2i(x-1, y-2))
							if plants.accounted_fertilized_tiles.has(initial + Vector2i(x-1, y-2)):
								plants.accounted_fertilized_tiles.erase(initial + Vector2i(x-1, y-2))
			if infected_tiles.has(cell_pos):
				if plants.plant_data[cell_pos]["type"] == "crop":
					infected.erase_cell(cell_pos)
					infected_tiles.erase(cell_pos)
				else:
					for x in 3:
						for y in 4:
							var initial = plants.plant_data[cell_pos]["initial"]
							
							infected_tiles.erase(initial + Vector2i(x-1, y-2))
							infected.erase_cell(initial + Vector2i(x-1, y-2))
	elif ToolVariables.current_tool == "Fertilizer":
		var mouse_pos = get_local_mouse_position()
		var cell_pos = local_to_map(mouse_pos)
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
	elif ToolVariables.current_tool == "Pesticide":
		var mouse_pos = get_local_mouse_position()
		var cell_pos = local_to_map(mouse_pos)
		
		if event.is_action_pressed("click"):
			if (plants.plant_data.has(cell_pos)):
				if (infected_tiles.has(cell_pos)):
					if plants.plant_data[cell_pos]["type"] == "crop":
						infected_tiles.erase(cell_pos)
						infected.erase_cell(cell_pos)
					elif plants.plant_data[cell_pos]["type"] == "tree":
						var initial = plants.plant_data[cell_pos]["initial"]
						for x in 3:
							for y in 4:
								infected_tiles.erase(initial + Vector2i(x-1, y-2))
								infected.erase_cell(initial + Vector2i(x-1, y-2))

func _process(delta: float):
	var mouse_pos = get_local_mouse_position()
	var cell_pos = local_to_map(mouse_pos)
	highlight(cell_pos)
	
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 23 && !spawned_pests_tutorial:
		spawned_pests_tutorial = true
		var count = 0
		for plant in plants.plant_data:
			infected_tiles.append(plant)
			infected.set_cell(plant, 0, Vector2i(0,0))
			count += 1
			if count >= 17:
				break
		
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 23:
		if infected_tiles.size() == 0 or infected.get_used_cells().size() == 0:
			tiles_values.emit()
			
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 10:
		var total_used = get_used_cells_by_id(1) + get_used_cells_by_id(2)
		if total_used.size() >= 18:
			tiles_values.emit()
	
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 20:		
		if watered_tiles.keys().size() >= 18:
			tiles_values.emit()
			
	for watered_tile in watered_tiles:
		watered_tiles[watered_tile]["time"] += delta
		if watered_tiles[watered_tile]["time"] >= upgrades.upgrades["Greater Soakage"]["Times"][upgrades.upgrades["Greater Soakage"]["Level"]-1]:
			if get_cell_source_id(watered_tile) == 2 || get_cell_source_id(watered_tile) == 1:
				set_cell(watered_tile, 1, Vector2i(0, 0))
			else:
				set_cell(watered_tile, 0, Vector2i(0, 0))
			if watered.get_cell_source_id(watered_tile) != -1:
				watered.erase_cell(watered_tile)
			watered_tiles.erase(watered_tile)
			
	for fertilized_tile in fertilized_tiles:
		fertilized_tiles[fertilized_tile]["time"] += delta
		if fertilized_tiles[fertilized_tile]["time"] >= 30:
			if fertilized.get_cell_source_id(fertilized_tile) != -1:
				fertilized.erase_cell(fertilized_tile)
			fertilized_tiles.erase(fertilized_tile)
			if plants.accounted_fertilized_tiles.has(fertilized_tile):
				plants.accounted_fertilized_tiles.erase(fertilized_tile)
				
	for plant in plants.plant_data:
		if !infected_tiles.has(plant):
			if !timers.has(plant):
				if plants.plant_data[plant]["type"] == "crop":
					var created_timer = get_tree().create_timer(15)
				
					timers[plant] = {"timer": created_timer}
				else:
					if plants.plant_data[plant]["initial"] == plant:
						var created_timer = get_tree().create_timer(15)
					
						timers[plant] = {"timer": created_timer}
			
	
	if PlayerVariables.player.completed_tutorial:
		for timer in timers:
			timers[timer]["timer"].timeout.connect(func ():
				if timers.has(timer):
					var rand = randi_range(1, 100000)
					if plants.plant_data.has(timer):
						if plants.plant_data[timer]["type"] == "crop":
							if rand > upgrades.upgrades["Bye-Bye Pests"]["Rates"][upgrades.upgrades["Bye-Bye Pests"]["Level"] - 1]:
								infected_tiles.append(timer)
								infected.set_cell(timer, 0, Vector2i(0,0))
						else:
							if rand > upgrades.upgrades["Bye-Bye Pests"]["Rates"][upgrades.upgrades["Bye-Bye Pests"]["Level"] - 1]:
								for x in 3:
									for y in 4:
										var initial = timer
										infected_tiles.append(initial + Vector2i(x-1, y-2))
										infected.set_cell(initial + Vector2i(x-1, y-2), 0, Vector2i(0, 0))
					timers.erase(timer)
			)
			
		
func highlight (cell_pos: Vector2i):
	select.position = map_to_local(cell_pos)


func _on_deny_pressed() -> void:
	pass # Replace with function body.


func _on_save_pressed() -> void:
	pass # Replace with function body.
