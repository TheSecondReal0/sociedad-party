extends Node

var game_info_dir = "res://game_info/"

signal switch_game_signal(game_res)
signal start_game_signal

func _ready():
	# set network master to server
	set_multiplayer_authority(1)
	# make it so when the game is paused, this script still runs
	process_mode = PROCESS_MODE_ALWAYS
#	print(get_game_resource_paths())
	print(get_game_resources())
	pass # Replace with function body.

@rpc func switch_game(game_name: String):
	var game_res: Resource = get_game_res_from_name(game_name)
	if game_res == null:
		return
	if Network.is_server():
		rpc("switch_game", game_name)
#	print("GameManager switching game to ", game_name)
	emit_signal("switch_game_signal", game_res)

@rpc func start_game():
	emit_signal("start_game_signal")
#	print("starting game")
	if Network.is_server():
		rpc("start_game")

func get_game_res_from_name(game_name) -> Resource:
	var resources: Dictionary = get_game_resources()
	if resources.has(game_name):
		return resources[game_name]
	return null

func get_game_resources() -> Dictionary:
	var resources: Dictionary = {}
	var resource_list: Array = Helpers.load_files_in_dir_with_exts(game_info_dir, [".tres"])
	
	for resource in resource_list:
		var game_name: String = resource.get_game_name()
#		print(game_name)
		resources[game_name] = resource
	
	return resources
