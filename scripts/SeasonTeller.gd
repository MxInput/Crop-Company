extends TextureRect

@onready var hand = get_child(0)

func _process(_delta: float) -> void:
	hand.rotation = (2 * PI * (SeasonVariables.season.time_in/SeasonVariables.length))
