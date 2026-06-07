extends TextureRect

@onready var tutorial = get_node("/root/Game/CanvasLayer/Tutorial")

func _process(_delta: float) -> void:
	if PlayerVariables.player.completed_tutorial:
		position.y -= 1
		modulate.a -= 0.0125
		if modulate.a <= 0:
			queue_free()
	elif tutorial.place > 0:
		position.y -= 1
		modulate.a -= 0.0125
		if modulate.a <= 0:
			queue_free()
	
