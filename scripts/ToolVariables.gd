extends Node

var current_tool

@onready var glove = get_node("/root/Game/CanvasLayer/Glove")
@onready var shovel = get_node("/root/Game/CanvasLayer/Shovel")
@onready var hoe = get_node("/root/Game/CanvasLayer/Hoe")

func _ready() -> void:
	current_tool = "Hoe"
	hoe.select()

func change_tool(tool : String):
	current_tool = tool

	match tool:
		"Shovel":
			shovel.select()
			hoe.deselect()
			glove.deselect()
			
		"Hoe":
			hoe.select()
			shovel.deselect()
			glove.deselect()
			
		"Glove":
			glove.select()
			shovel.deselect()
			hoe.deselect()
			
	
	
