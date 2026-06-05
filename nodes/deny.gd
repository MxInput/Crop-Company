extends TextureButton

@onready var toolbar = get_node("/root/Game/CanvasLayer/Toolbar")	

func _on_pressed() -> void:
	get_parent().visible = false
	PlayerVariables.player.completed_tutorial = true
	
	toolbar.unlock_plant(["Banana"])
	
	for to_activate in get_parent().activates:
		get_parent().activates[to_activate].visible = true
