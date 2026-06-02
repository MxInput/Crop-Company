extends Area2D

@onready var dragged_obj: Node2D = get_node("/root/Game/Dragged")
@onready var plants: TileMapLayer = get_node("/root/Game/Plants")
@onready var terrain: TileMapLayer = get_node("/root/Game/Terrain")
@onready var camera: Camera2D = get_node("/root/Game/Camera2D")

@onready var overview: Control = get_node("/root/Game/CanvasLayer/Overview")

@onready var tree_placement: Node2D = get_node("/root/Game/Plants/TreePlacement")

@export var one_select : CompressedTexture2D
@export var nine_select : CompressedTexture2D

var num_spaces = 1

func _input(event: InputEvent) -> void:
	if HoverVariables.hovered_on == get_parent().name:
		if !plants.tree_info.get(get_parent().name):
			if event.is_action_pressed("scroll_up") or event.is_action_pressed("scroll_down"):
				match num_spaces:
					1:
						num_spaces = 9
						terrain.change_select_to_nine()
					9:
						num_spaces = 1
						terrain.change_select_to_one()
		
func _process(_delta: float) -> void:
	if HoverVariables.hovered_on == "": 
		overview.deactivate("toolbar")
		
	if HoverVariables.hovered_on == get_parent().name:			
		if HoverVariables.dragging != get_parent().name:
			overview.inventory(get_parent().name)
		else:
			overview.deactivate("toolbar")
		if Input.is_action_pressed("click"):
			if !plants.tree_info.get(get_parent().name):
				dragged_obj.global_position = dragged_obj.get_global_mouse_position()
					
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
				
			plants.plant(get_parent().name, num_spaces)
			HoverVariables.hovered_on = ""
			HoverVariables.dragging = ""
			
			num_spaces = 1
			terrain.num_spaces = 1
			terrain.change_select_to_one()

func _on_mouse_entered() -> void:
	if HoverVariables.dragging == "":
		terrain.num_spaces = 1
		terrain.change_select_to_one()
		
		num_spaces = 1
		
		HoverVariables.hovered_on = get_parent().name
		
func _on_mouse_exited() -> void:
	if HoverVariables.dragging == "" && HoverVariables.hovered_on == get_parent().name:
		num_spaces = 1
		terrain.num_spaces =1
		terrain.change_select_to_one()
					
		HoverVariables.hovered_on = ""

		
