extends TextureButton

@export var norm = load("res://tiles/toolbar/tree_bar.png")
@export var selected = load("res://tiles/toolbar/tree_bar.png")
var clip_mask = load("res://tiles/clip_mask.png")

func _ready() -> void:
	var bitmap = BitMap.new()
	bitmap.create_from_image_alpha(clip_mask.get_image())
	texture_click_mask = bitmap
		
	texture_normal = norm
	texture_pressed = norm
	texture_hover = selected
	texture_disabled = norm
	texture_focused = norm
	
	if name == "Hoe":
		select()

func _on_pressed() -> void:
	ToolVariables.change_tool(name)

func select():
	texture_normal = selected

func deselect():
	texture_normal = norm
