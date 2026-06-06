extends Node

@onready var saveManager = get_node("SaveManager") 

func _on_ready() -> void:
	saveManager.load_game()
