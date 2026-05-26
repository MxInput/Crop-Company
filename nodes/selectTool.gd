extends Button

@export var norm = load("res://tiles/toolbar/tree_bar.png")
@export var selected = load("res://tiles/toolbar/tree_bar.png")

func _on_pressed() -> void:
	ToolVariables.change_tool(name)

func select():
	icon = selected

func deselect():
	icon = norm
