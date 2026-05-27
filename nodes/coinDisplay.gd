extends Node

@onready var canvas_layer : CanvasLayer = get_node("/root/Game/CanvasLayer")

@onready var coin_change = preload("res://nodes/CoinChange.tscn")

var coin_changes = []

func new_instance(amount : float):
	if amount < 0:
		var instance = coin_change.instantiate()
		canvas_layer.add_child(instance)
		instance.global_position += Vector2(200, 100)
	else:
		var instance = coin_change.instantiate()
		canvas_layer.add_child(instance) 

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
