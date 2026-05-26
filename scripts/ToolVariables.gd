extends Node

var current_tool

func _ready() -> void:
	current_tool = "Hoe"

func change_tool(tool : String):
	current_tool = tool
