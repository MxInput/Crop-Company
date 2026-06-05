extends TextureRect

func _process(delta: float) -> void:
	position.y -= 1
	modulate.a -= 0.0125
	if modulate.a <= 0:
		queue_free()
	
