extends Area2D

@onready var dragged_obj: Node2D = get_node("/root/Game/Dragged")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var camera: Camera2D = get_node("/root/Game/Camera2D")

@onready var tree_placement: Node2D = get_node("/root/Game/Plants/TreePlacement")

func _process(_delta: float) -> void:
	if HoverVariables.hovered_on == get_parent().name:
		if Input.is_action_pressed("click"):
			if !plants.tree_info.get(get_parent().name):
				var global_pos = get_global_mouse_position()
				dragged_obj.global_position = global_pos - Vector2(572 - camera.position.x, 310 - camera.position.y)
					
				dragged_obj.visible = true
				dragged_obj.get_child(0).texture = self.get_parent().get_child(0).texture
				dragged_obj.modulate.a = 0.75
					
				HoverVariables.dragging = get_parent().name
			else:
				plants.move_placement()
				HoverVariables.dragging = get_parent().name
				
	if Input.is_action_just_released("click"):
		if HoverVariables.dragging == get_parent().name:
			if !plants.tree_info.get(get_parent().name):
				dragged_obj.visible = false
			else:
				tree_placement.visible = false
				
			plants.plant(get_parent().name)
			HoverVariables.hovered_on = ""
			HoverVariables.dragging = ""

func _on_mouse_entered() -> void:
	if HoverVariables.dragging == "":
		HoverVariables.hovered_on = get_parent().name
		
func _on_mouse_exited() -> void:
	if HoverVariables.dragging == "" && HoverVariables.hovered_on == get_parent().name:
		HoverVariables.hovered_on = ""
