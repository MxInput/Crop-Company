extends Label

func _process(_delta: float) -> void:
	text = "Coins: " + str(PlayerVariables.player.coins)
