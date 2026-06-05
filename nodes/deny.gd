extends TextureButton

func _on_pressed() -> void:
	get_parent().visible = false
	PlayerVariables.player.completed_tutorial = true
	
	for to_activate in get_parent().activates:
		get_parent().activates[to_activate].visible = true
