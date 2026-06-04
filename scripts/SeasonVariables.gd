extends Node

var season = Season.new()
var length = 420

@onready var clock: TextureRect = get_node("/root/Game/CanvasLayer/Clock")

var season_clocks = {
	"Spring": load("res://UI/Clock/spring.png"),
	"Summer": load("res://UI/Clock/summer.png"),
	"Fall": load("res://UI/Clock/fall.png"),
	"Winter": load("res://UI/Clock/winter.png")
}

func _ready() -> void:
	season.name = "Spring"
	season.time_in = 0

func _process(delta: float) -> void:
	season.clock(delta)
	if season.time_in > length:
		season.change()
		
		clock.texture = season_clocks[season.name]
