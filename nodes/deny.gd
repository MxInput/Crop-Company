extends TextureButton

func _on_pressed() -> void:
	get_parent().visible = false
	PlayerVariables.player.completed_tutorial = true
