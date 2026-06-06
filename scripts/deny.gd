extends TextureButton

@onready var toolbar = get_node("/root/Game/CanvasLayer/Toolbar")	
@onready var quests = get_node("/root/Game/Quests")	

func _on_pressed() -> void:
	get_parent().visible = false
	PlayerVariables.player.completed_tutorial = true
	
	toolbar.unlock_plant(["Banana"])
	
	quests.quests["Complete the Tutorial (or skip it)"]["Completed"] = true
	
	for to_activate in get_parent().activates:
		get_parent().activates[to_activate].visible = true
