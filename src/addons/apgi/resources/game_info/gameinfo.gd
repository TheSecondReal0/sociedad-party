tool
extends Resource

class_name GameInfo

export var game_name: String
export(String, MULTILINE) var game_description
export(int, 1, 10) var rounds = 1
export(bool) var timer
export(String, FILE, "*.tscn") var main_scene_path
export var unique_server_main: bool = false
export(String, FILE, "*.tscn") var server_main_scene_path

func get_game_name() -> String:
	return game_name

func get_game_desc() -> String:
	return game_description

func get_main_scene() -> Resource:
	return load(main_scene_path)

func get_server_main_scene() -> Resource:
	if unique_server_main:
		return load(server_main_scene_path)
	return load(main_scene_path)
