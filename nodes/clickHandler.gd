extends Camera2D

func  _input(event):
	if event is InputEventMouseButton:
		var mouse_pos = to_local(event.position)
