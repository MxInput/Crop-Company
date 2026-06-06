extends TextureButton

@export var menu : TextureRect

func _on_pressed() -> void:
	if menu.visible:
		menu.visible = false
