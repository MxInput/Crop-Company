extends Camera2D

var pan_dis = 10
	
var min_zoom = Vector2(0.75,0.75)
var max_zoom = Vector2(2.5,2.5)
var zoom_speed = Vector2(0.3,0.3)

@onready var tutorial = get_node("/root/Game/CanvasLayer/Tutorial")

signal moving_camera
	
func _ready() -> void:
	moving_camera.connect(tutorial.change)
	
func _input(event):
	if event.is_action("zoom_out"):
		if zoom > min_zoom:
			zoom -= zoom_speed
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 2:
				moving_camera.emit()
	if event.is_action("zoom_in"):
		if zoom < max_zoom:
			zoom += zoom_speed
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 2:
				moving_camera.emit()
	
	if event.is_action("move_up"):
		if position.y - (get_viewport_rect().size.y/2.0) / zoom.y > limit_top:
			position.y -= pan_dis
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 1:
				moving_camera.emit()
	if event.is_action("move_down"):
		if position.y + (get_viewport_rect().size.y/2.0) / zoom.y < limit_bottom:
			position.y += pan_dis
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 1:	
				moving_camera.emit()
	if event.is_action("move_left"):
		if position.x - (get_viewport_rect().size.x/2.0) / zoom.x > limit_left:
			position.x -= pan_dis 
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 1:	
				moving_camera.emit()
	if event.is_action("move_right"):
		if position.x + (get_viewport_rect().size.x/2.0) / zoom.x < limit_right:
			position.x += pan_dis
			if !PlayerVariables.player.completed_tutorial && tutorial.place == 1:	
				moving_camera.emit()
