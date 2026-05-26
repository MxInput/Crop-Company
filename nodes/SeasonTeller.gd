extends Label

func _process(delta: float) -> void:
	text = "Season: " + SeasonVariables.season.name + " Time In: " + str(ceil(SeasonVariables.season.time_in))
