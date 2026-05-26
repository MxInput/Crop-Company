extends Label

func _process(_delta: float) -> void:
	text = str(PlayerVariables.player.coins)
	get_child(0).text = text
