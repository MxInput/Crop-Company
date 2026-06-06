extends TextureButton

@export var menu : TextureRect
@export var other_menu : TextureRect

func _on_pressed() -> void:
	if menu.visible:
		menu.visible = false
	else:
		menu.visible = true
		if other_menu.visible:
			other_menu.visible = false
