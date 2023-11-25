extends Node2D

@export var host_ui_res: Resource
@export var score_ui_res: Resource

@onready var non_game_children: Array = [$ui_controller]

var open_timer_res: Resource = load("res://ui/timer_ui/open_timer_ui.tres")
var current_game: Node

func _ready():
	# make it so when the game is paused, this script still runs
	process_mode = PROCESS_MODE_ALWAYS
# warning-ignore:return_value_discarded
	GameManager.connect("switch_game_signal", Callable(self, "switch_game"))
# warning-ignore:return_value_discarded
	GameManager.connect("start_game_signal", Callable(self, "start_game"))
#	print(Network.is_network_server())
	if Network.is_server():
		print("interacting with host ui")
		host_ui_res.interact()
	score_ui_res.interact()
#	print("asaio party main loaded")

func switch_game(game_res):
	unload_game()
	if not load_game(game_res):
		print("failed to load game")
		return
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
	var server: bool = Network.is_server()
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
	var game = game_scene.instantiate()
	game.process_mode = PROCESS_MODE_PAUSABLE
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
