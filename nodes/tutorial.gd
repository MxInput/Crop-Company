extends TextureRect

var tutorial_text = [
	"Welcome to Crop Company! Would you like to play the tutorial?",
	"Move the camera by pressing W, A, S, and D or the arrow keys.",
	"Zoom in and out by pressing Q and E."
]



func _ready() -> void:
	if !PlayerVariables.player.completed_tutorial:
		visible = true
		get_child(0).text = tutorial_text[0]
