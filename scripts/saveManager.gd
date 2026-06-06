extends Node

const SAVE_PATH := "user://simple_save.tres"

var save_game: SaveGame = null

func _ready() -> void:
	if ResourceLoader.exists(SAVE_PATH):
		save_game = ResourceLoader.load(SAVE_PATH, "", ResourceLoader.CACHE_MODE_IGNORE)
	else:
		save_game = SaveGame.new()
	
func save() -> void:
	save_game = SaveGame.new()
	
	save_game.player_coins = PlayerVariables.player.coins
	save_game.player_completed_tutorial = PlayerVariables.player.completed_tutorial
	
	save_game.season_name = SeasonVariables.season.name
	save_game.season_time_in = SeasonVariables.season.time_in

	save_game.tiles = {
		"Terrain": get_node("/root/Game/Terrain").num_spaces
	}
	ResourceSaver.save(save_game, SAVE_PATH)	

func load_game():
	save_game = ResourceLoader.load(SAVE_PATH)	
	
	if save_game != null:
		PlayerVariables.player.coins = save_game.player_coins
		PlayerVariables.player.completed_tutorial = save_game.player_completed_tutorial
		
		SeasonVariables.season.name = save_game.season_name
		SeasonVariables.season.time_in = save_game.season_time_in

		print(save_game.tiles["Terrain"])

func _on_save_pressed() -> void:
	save()
