extends Area2D

var is_hovered_on: bool = false
var being_dragged: bool = false

@onready var dragged_obj: Node2D = get_node("/root/Game/Dragged")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")

func _process(_delta: float) -> void:
	if is_hovered_on:
		if Input.is_action_pressed("click"):
			var global_pos = get_global_mouse_position()
			dragged_obj.global_position = global_pos - Vector2(572, 310)
			
			dragged_obj.visible = true
			dragged_obj.get_child(0).texture = self.get_parent().get_child(0).texture
			dragged_obj.modulate.a = 0.75
			
			being_dragged = true
		elif Input.is_action_just_released("click"):
			plants.plant()
			being_dragged = false
			dragged_obj.visible = false
			is_hovered_on = false	
	pass
	
func _on_mouse_entered() -> void:
	is_hovered_on = true
	pass # Replace with function body.
