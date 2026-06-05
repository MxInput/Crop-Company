extends Node

var current_tool

@onready var glove = get_node("/root/Game/CanvasLayer/Glove")
@onready var shovel = get_node("/root/Game/CanvasLayer/Shovel")
@onready var hoe = get_node("/root/Game/CanvasLayer/Hoe")
@onready var pesticide = get_node("/root/Game/CanvasLayer/Pesticide")
@onready var watering_can = get_node("/root/Game/CanvasLayer/WateringCan")
@onready var fertilizer = get_node("/root/Game/CanvasLayer/Fertilizer")

@onready var tools = [glove, shovel, hoe, pesticide, watering_can, fertilizer]

@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")

@onready var tutorial = get_node("/root/Game/CanvasLayer/Tutorial")

signal tool_selected

func _ready() -> void:
	change_tool("Glove")
	
	tool_selected.connect(tutorial.change)

func change_tool(tool : String):
	if current_tool != null:
		terrain.num_spaces = 1
		terrain.change_select_to_one()

	current_tool = tool
	
	if !PlayerVariables.player.completed_tutorial && tutorial.place == 7:
		if current_tool == "Hoe":
			tool_selected.emit()

	for foundTool in tools:
		if tool == foundTool.name:
			foundTool.select()
		else:
			foundTool.deselect()
