extends Node

@onready var canvas_layer : CanvasLayer = get_node("/root/Game/CanvasLayer")

@onready var coin_change = preload("res://nodes/CoinChange.tscn")

var coin_changes = []

func tell_warning(words : String):
	var instance = coin_change.instantiate()
	canvas_layer.add_child(instance)
	
	instance.global_position += Vector2(50, 50)
	instance.get_child(0).text =words
	
	var dec_color = Color(0.622, 0.195, 0.225, 1.0)
	
	instance.get_child(0).set("theme_override_colors/font_color",dec_color) 
	
	coin_changes.append(instance)
	
func new_instance(amount : float):
	var instance = coin_change.instantiate()
	canvas_layer.add_child(instance)
	
	instance.global_position += Vector2(50, 50)
	instance.get_child(0).text = str(amount)
	
	var dec_color = Color(0.622, 0.195, 0.225, 1.0)
	var inc_color =	Color(0.242, 0.541, 0.501, 1.0)
	var inc_color_shadow = Color(0.073, 0.291, 0.3, 1.0)
	
	if amount < 0:
		instance.get_child(0).set("theme_override_colors/font_color",dec_color) 
	else:
		instance.get_child(0).set("theme_override_colors/font_color",inc_color)
		instance.get_child(0).set("theme_override_colors/font_shadow_color",inc_color_shadow)
	
	coin_changes.append(instance)
	
func _process(delta: float) -> void:
	for instance in coin_changes:
		instance.position.y -= 1
		instance.modulate.a -= 0.05
		if instance.modulate.a <= 0:
			coin_changes.erase(instance)
			instance.queue_free()
		
