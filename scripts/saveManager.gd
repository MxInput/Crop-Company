extends Node

const SAVE_PATH = "user://savegame.json"
var current_data = {}

func save_game():
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("persist")
	for node in save_nodes:		
		var node_data = node.call("save")

		var json_string = JSON.stringify(node_data)

		save_file.store_line(json_string)
	var player_data = {"name": "Player", "coins": PlayerVariables.player.coins, "completed_tutorial": PlayerVariables.player.completed_tutorial}
	var season_data = {"name": "Season", "season_name": SeasonVariables.season.name, "time_left": SeasonVariables.season.time_in} 
	
	var player_data_string = JSON.stringify(player_data)
	var season_data_string = JSON.stringify(season_data)
	
	save_file.store_line(player_data_string)
	save_file.store_line(season_data_string)
	
func load_game():
	if not FileAccess.file_exists(SAVE_PATH):
		return 
		
	var save_nodes = get_tree().get_nodes_in_group("persist")
		
	var save_file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	while save_file.get_position() < save_file.get_length():
		var json_string = save_file.get_line()
		
		var json = JSON.new()

		var parse_result = json.parse(json_string)
		if not parse_result == OK:
			continue
			
		var node_data = json.data

		for node in save_nodes:	
			if node_data.has("name"):
				if node_data["name"] == node.name:
					node.load(node_data)
		if node_data.has("name"):
			if node_data["name"] == "Player":
				PlayerVariables.player.coins = int(node_data["coins"])
				PlayerVariables.player.completed_tutorial = node_data["completed_tutorial"]
			elif node_data["name"] == "Season":
				SeasonVariables.season.name = node_data["season_name"]
				SeasonVariables.season.time_in = node_data["time_left"]
							
		
		
		
		
