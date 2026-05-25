extends Camera2D

var pan_dis = 10
	
var min_zoom = Vector2(0.75,0.75)
var max_zoom = Vector2(2.5,2.5)
var zoom_speed = Vector2(0.3,0.3)

func _input(event):
	if event.is_action("zoom_out"):
		if zoom > min_zoom:
			zoom -= zoom_speed
	if event.is_action("zoom_in"):
		if zoom < max_zoom:
			zoom += zoom_speed
	
	if event.is_action("move_up"):
		position.y -= pan_dis
	if event.is_action("move_down"):
		position.y += pan_dis
	if event.is_action("move_left"):
		position.x -= pan_dis 
	if event.is_action("move_right"):
		position.x += pan_dis
	pass
	
