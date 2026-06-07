extends Node

var player = Player.new()

func _ready() -> void:
	player.coins = 500
	player.completed_tutorial = false
