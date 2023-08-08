extends Node2D

export(Resource) var host_ui_res
export(Resource) var score_ui_res

onready var non_game_children: Array = [$ui_controller]

var open_timer_res: Resource = load("res://assets/ui/timer_ui/open_timer_ui.tres")
var current_game: Node

func _ready():
	# make it so when the game is paused, this script still runs
	pause_mode = PAUSE_MODE_PROCESS
# warning-ignore:return_value_discarded
	GameManager.connect("switch_game", self, "switch_game")
# warning-ignore:return_value_discarded
	GameManager.connect("start_game", self, "start_game")
	#print(get_tree().is_network_server())
	if get_tree().is_network_server():
		host_ui_res.interact()
	score_ui_res.interact()
	ScoreManager.reset_scores()
#	print("asaio party main loaded")

func switch_game(game_res):
	unload_game()
	if not load_game(game_res):
		print("failed to load game")
		return
	ScoreManager.reset_scores()
	if current_game.has_method("setup"):
		current_game.setup()
#	print("current game at switch: ", current_game)
	if game_res.timer:
		get_tree().paused = true
		# open timer ui
		open_timer_res.interact()
	else:
		start_game()

func start_game():
	get_tree().paused = false
#	if current_game == null:
#		return
#	print("current game at start: ", current_game)
	if current_game.has_method("start"):
		current_game.start()

func load_game(game_res) -> bool:
	var server: bool = get_tree().is_network_server()
	# get scene for game to load
	var game_scene: PackedScene
	if server:
		game_scene = game_res.get_server_main_scene()
	else:
		game_scene = game_res.get_main_scene()
	# if game scene doesn't exist return
	# prevents crash
#	print(game_scene.resource_path)
	if game_scene == null:
		return false
	# create game node and add it to tree
	var game = game_scene.instance()
	game.pause_mode = PAUSE_MODE_STOP
	game.name = game_res.get_game_name()
	add_child(game)
	current_game = game
	return true

func unload_game():
	if current_game != null:
		if current_game.has_method("cleanup"):
			current_game.cleanup()
	for node in get_children():
		if not non_game_children.has(node):
			# renaming it before deleting prevents networking from shitting itself
			node.name = node.name + "deleting"
			node.queue_free()
