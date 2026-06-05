extends TextureRect

var place = 0
var timer = Timer.new()

@onready var continue_button = get_child(3)

var tutorial_text = [
	"Welcome to Crop Company! Would you like to play the tutorial?",
	"Move the camera by pressing W, A, S, and D or the arrow keys.",
	"Zoom in and out by pressing Q and E.",
	"The icon that just appeared showed how many coins you have.",
	"The clock that appeared now shows the current season.",
	"Only in season crops will grow and be planted.",
	"The left buttons are your tools.",
	"Select the hoe icon.",
	"Till at least 10 tiles."
]

@onready var activates = {
	"Coins": get_node("/root/Game/CanvasLayer/TextureRect"),
	"Toolbar": get_node("/root/Game/CanvasLayer/Toolbar"),
	
	"Watering Can": get_node("/root/Game/CanvasLayer/WateringCan"),
	"Pesticide": get_node("/root/Game/CanvasLayer/Pesticide"),
	"Fertilizer": get_node("/root/Game/CanvasLayer/Fertilizer"),
	"Shovel": get_node("/root/Game/CanvasLayer/Shovel"),
	"Glove": get_node("/root/Game/CanvasLayer/Glove"),
	"Hoe": get_node("/root/Game/CanvasLayer/Hoe"),
	
	"Clock": get_node("/root/Game/CanvasLayer/Clock"),
	
	"Upgrade Button": get_node("/root/Game/CanvasLayer/UpgradeButton"),
	"Quest Button": get_node("/root/Game/CanvasLayer/QuestButton")
}

func change():
	if place < tutorial_text.size() - 1:
		if timer.is_stopped():
			timer.start()
		
func _ready() -> void:
	timer.wait_time = 2
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(place_up)
	
	if !PlayerVariables.player.completed_tutorial:
		for activate in activates:
			activates[activate].visible = false
			
		visible = true
		get_child(0).text = tutorial_text[0]
			
func place_up():
	timer.stop()
	
	place += 1
	get_child(0).text = tutorial_text[place]
	
	if place == 3:
		activates["Coins"].visible = true
		continue_button.visible = true
	if place == 4:
		activates["Clock"].visible = true
	if place == 6:
		activates["Pesticide"].visible = true
		activates["Glove"].visible = true
		activates["Hoe"].visible = true
		activates["Shovel"].visible = true
		activates["Fertilizer"].visible = true
		activates["Watering Can"].visible = true
	if place == 7:
		continue_button.visible = false
			
func _on_confirm_pressed() -> void:
	get_child(1).visible = false
	get_child(2).visible = false
	
	get_child(0).text = tutorial_text[1]
	place = 1
	


func _on_continue_pressed() -> void:
	place_up()
