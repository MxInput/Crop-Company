extends Node

var season = Season.new()
var length = 420
var seasons_experienced = 0

@onready var clock: TextureRect = get_node("/root/Game/CanvasLayer/Clock")

@onready var quests = get_node("/root/Game/Quests")

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
		
		if seasons_experienced < 4:
			seasons_experienced += 1	
	
	if !quests.quests["Experience all seasons and make it back to Spring"]["Completed"]:
		if seasons_experienced >= 4:
			quests.quests["Experience all seasons and make it back to Spring"]["Completed"] = true
		
	if !quests.quests["Reach Summer"]["Completed"]:
		if season.name == "Summer":
			quests.quests["Reach Summer"]["Completed"] = true
