extends TextureButton

signal purchased_upgrade

@onready var upgrades = get_node("/root/Game/Upgrades")
	
func change_back() -> void:
	get_child(0).text = "PURCHASE"
	
func _ready() -> void:
	purchased_upgrade.connect(upgrades.bought)
	
func _on_pressed() -> void:
	purchased_upgrade.emit(self, get_parent().name)
