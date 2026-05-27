extends Node

var current_tool

@onready var glove = get_node("/root/Game/CanvasLayer/Glove")
@onready var shovel = get_node("/root/Game/CanvasLayer/Shovel")
@onready var hoe = get_node("/root/Game/CanvasLayer/Hoe")
@onready var pesticide = get_node("/root/Game/CanvasLayer/Pesticide")
@onready var watering_can = get_node("/root/Game/CanvasLayer/WateringCan")
@onready var fertilizer = get_node("/root/Game/CanvasLayer/Fertilizer")

@onready var tools = [glove, shovel, hoe, pesticide, watering_can, fertilizer]

func _ready() -> void:
	current_tool = "Hoe"
	hoe.select()

func change_tool(tool : String):
	current_tool = tool

	for foundTool in tools:
		if tool == foundTool.name:
			foundTool.select()
		else:
			foundTool.deselect()
