@tool
extends Resource

class_name GameInfo

@export var game_name: String
@export_multiline var game_description: String # (String, MULTILINE)
@export var rounds: int = 1 # (int, 1, 10)
@export var timer: bool
@export_file("*.tscn") var main_scene_path # (String, FILE, "*.tscn")
@export var unique_server_main: bool = false
@export_file("*.tscn") var server_main_scene_path # (String, FILE, "*.tscn")

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
