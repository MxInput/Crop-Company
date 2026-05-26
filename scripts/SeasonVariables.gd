extends Node

var season = Season.new()
var length = 1200

func _ready() -> void:
	season.name = "Spring"
	season.time_in = 0

func _process(delta: float) -> void:
	season.clock(delta)
	if season.time_in > length:
		season.change()
