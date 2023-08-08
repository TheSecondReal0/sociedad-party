extends Node

var game_info_dir = "res://game_info/"

signal switch_game(game_res)
signal start_game

func _ready():
	# set network master to server
	set_network_master(1)
	# make it so when the game is paused, this script still runs
	pause_mode = PAUSE_MODE_PROCESS
#	print(get_game_resource_paths())
	print(get_game_resources())
	pass # Replace with function body.

puppet func switch_game(game_name: String):
	var game_res: Resource = get_game_res_from_name(game_name)
	if game_res == null:
		return
	if get_tree().is_network_server():
		rpc("switch_game", game_name)
#	print("GameManager switching game to ", game_name)
	emit_signal("switch_game", game_res)

puppet func start_game():
	emit_signal("start_game")
#	print("starting game")
	if get_tree().is_network_server():
		rpc("start_game")

func get_game_res_from_name(game_name) -> Resource:
	var resources: Dictionary = get_game_resources()
	if resources.has(game_name):
		return resources[game_name]
	return null

func get_game_resources() -> Dictionary:
	var resources: Dictionary = {}
	var paths = get_game_resource_paths()
	
	for path in paths:
		var resource = load(path)
		var game_name: String = resource.get_game_name()
#		print(game_name)
		resources[game_name] = resource
	
	return resources

func get_game_resource_paths() -> Array:
	var paths: Array = []
	var dir = Directory.new()
	dir.open(game_info_dir)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			# completely break out of the loop
			break
		if not file.ends_with(".tres") or not file.ends_with("res"):
			# stop this iteration, but keep the loop going
			continue
		paths.append(game_info_dir + file)
	
	dir.list_dir_end()
	return paths

