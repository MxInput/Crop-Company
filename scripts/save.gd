extends TextureButton

func _on_pressed() -> void:
	SaveManager.save_game()
