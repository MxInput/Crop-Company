extends Node

@onready var saveManager = get_node("SaveManager") 

func _on_ready() -> void:
	if saveManager.able_to_load():
		saveManager.load_game()
