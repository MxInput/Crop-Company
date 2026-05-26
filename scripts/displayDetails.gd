extends Control

@onready var stageTeller = get_child(0).get_child(0)
@onready var nameTeller = get_child(0).get_child(1)
@onready var timeTeller = get_child(0).get_child(2)

func display(stage : String, givenName : String, time : String) -> void:
	global_position = get_global_mouse_position() + Vector2(-40, -150)
	visible = true
	stageTeller.text = "Stage " + stage + " / 4"
	stageTeller.get_child(0).text = stageTeller.text
	nameTeller.text = givenName
	nameTeller.get_child(0).text = nameTeller.text
	if stage == "4":
		timeTeller.text = "Ready to harvest"
	else:
		timeTeller.text = "Time until next stage: " + time
	timeTeller.get_child(0).text = timeTeller.text
	
