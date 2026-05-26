extends Area2D

@onready var dragged_obj: Node2D = get_node("/root/Game/Dragged")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var toolbar: Control = get_node("/root/Game/CanvasLayer/Toolbar")

func _process(_delta: float) -> void:
	if toolbar.hovered_on == get_parent().name:
		if Input.is_action_pressed("click", false):
			var global_pos = get_global_mouse_position()
			dragged_obj.global_position = global_pos - Vector2(572, 310)
				
			dragged_obj.visible = true
			dragged_obj.get_child(0).texture = self.get_parent().get_child(0).texture
			dragged_obj.modulate.a = 0.75
				
			toolbar.dragging = get_parent().name
	if Input.is_action_just_released("click", false):
		print("drag:" + toolbar.dragging, "parent" + get_parent().name)
		if toolbar.dragging == get_parent().name:
			plants.plant(self.get_parent().name)
		dragged_obj.visible = false
		toolbar.hovered_on = ""
		toolbar.dragging = ""
	pass
	
func _on_mouse_entered() -> void:
	if toolbar.dragging == "":
		toolbar.hovered_on = get_parent().name
	pass # Replace with function body.
