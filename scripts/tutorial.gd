extends TextureRect

var place = 0
var timer = Timer.new()

@onready var quests = get_node("/root/Game/Quests")

@onready var continue_button = get_child(3)

@onready var spring = get_child(6)
@onready var summer = get_child(7)
@onready var winter = get_child(4)
@onready var fall = get_child(5)

@onready var toolbar = get_node("/root/Game/CanvasLayer/Toolbar")	

const SAVE_PATH := "user://simple_save.tres"

var tutorial_text = [
	"Welcome to Crop Company! Would you like to play the tutorial?",
	"Move the camera by pressing W, A, S, and D or the arrow keys.",
	"Zoom in and out by pressing Q and E.",
	"The icon that appeared displays how many coins you have.",
	"The clock that appeared now shows the current season.",
	"Only crops that are in season will grow and are able to be planted.",
	"The left buttons are your tools.",
	"Select the hoe icon.",
	"Scroll up and down to change the till size.",
	"Click to till a tile and click the tilled tile to untill it.",
	"Till (at least) 18 tiles.",
	"The toolbar that just appeared displays all crops that can be planted.",
	"Right now, only carrots and bananas are unlocked.",
	"Hover over the carrot icon.",
	"The overview that appears provides information on the plant including its name, growth time, sell price, buy price, and the seasons it grows in.",
	"Drag the carrot, scroll to change the how much you want to plant, and place it onto a tilled tile to plant it.",
	"Plant (at least) 18 carrots.",
	"Hover over any planted tile.",
	"This overview tells you the plant's name, current stage, time left growing, and whether it is in season.",
	"Click on the shovel.",
	"Click on at least one of the planted carrots to remove it. Once removed you are repaid the price that was originally paid to plant it.",
	"Click on the fertilizer bag icon. Click on at least 17 tiles to lessen the time it takes for them to grow by appling fertilizer.",
	"Plants only grow when watered. Click on the watering can then, click on the carrot seeds to water them. Water at least 17 of them.",
	"Oh no, some pests appeared! Click on the pesticide icon then, click on the infested tiles to remove them.",
	"It typically takes time for plants to grow, but right now let's speed it up! Click to harvest at least one completed tile. Clicking and holding harvests multiple tiles.",
	"Till tiles in a 2x3 pattern and place at least one now unlocked banana tree.",
	"Trees, unlike normal crops, can be harvested multiple times without disappearing.",
	"The button that appeared can be used to access upgrades that you can buy.",
	"The other button that appeared can be used to access quests that you can complete for rewards.",
	"Clicking this button marks the end of the tutorial."
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
	"Quest Button": get_node("/root/Game/CanvasLayer/QuestButton"),
	
	"Save Button": get_node("/root/Game/CanvasLayer/Save")
}

func change():
	if place < tutorial_text.size() - 1:
		if timer.is_stopped():
			timer.start()
		
func _ready() -> void:
	timer.wait_time = 1.5
	timer.one_shot = true
	add_child(timer)
	timer.timeout.connect(place_up)
	
	if !PlayerVariables.player.completed_tutorial && ResourceLoader.load(SAVE_PATH) == null:
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
		
		spring.visible = true
		summer.visible = true
		fall.visible = true
		winter.visible = true
	if place == 6:
		activates["Glove"].visible = true
		activates["Hoe"].visible = true
		
		spring.visible = false
		summer.visible = false
		fall.visible = false
		winter.visible = false
	if place == 7:
		continue_button.visible = false
	if place == 8:
		continue_button.visible = true
	if place == 10:
		continue_button.visible = false
	if place == 11:
		activates["Toolbar"].visible = true
		continue_button.visible = true
	if place == 13:
		continue_button.visible = false
	if place == 14:
		continue_button.visible = true
	if place == 16:
		continue_button.visible = false
	if place == 18:
		continue_button.visible = true
	if place == 19:
		activates["Shovel"].visible = true
		continue_button.visible = false
	if place == 21:		
		activates["Fertilizer"].visible = true
	if place == 22:		
		activates["Watering Can"].visible = true	
	if place == 23:		
		activates["Pesticide"].visible = true
	if place == 25:		
		toolbar.unlock_plant(["Banana"])
	if place == 26:		
		continue_button.visible = true
	if place == 27:		
		activates["Upgrade Button"].visible = true
	if place == 28:		
		activates["Quest Button"].visible = true

func _on_confirm_pressed() -> void:
	get_child(1).visible = false
	get_child(2).visible = false
	
	get_child(0).text = tutorial_text[1]
	place = 1
	
func _on_continue_pressed() -> void:
	if place == 29:		
		visible = false
		activates["Save Button"].visible = true
		quests.quests["Complete the Tutorial (or skip it)"]["Completed"] = true
		PlayerVariables.player.completed_tutorial = true
	else:
		place_up()
	
