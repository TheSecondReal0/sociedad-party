extends Node2D

export(String, FILE, "*.tscn") var player_scene_path
export(Resource) var close_dash_ui

onready var movement_target: Node = $movement_target
onready var soul_spawn_timer: Timer = $soul_spawn_timer

var player_scene: PackedScene = load("res://games/reaper/player/reaperplayer.tscn")
var soul_scene: PackedScene = load("res://games/reaper/souls/person/person.tscn")

func setup():
	movement_target.color = Network.get_my_color()
	if get_tree().is_network_server():
		create_players()
#		for _i in 10:
#			spawn_soul()

func start():
	if get_tree().is_network_server():
		soul_spawn_timer.start()

func cleanup():
	close_dash_ui.interact()

func create_players():
	for peer in Network.get_peers():
		create_player(peer)

func create_player(id: int):
	var new_player: Node = player_scene.instance()
	var spawnpoint: Vector2 = Vector2(512, 300)#Vector2(rand_range(100, 924), rand_range(100, 500))
	new_player.name = str(id)
	new_player.color = Network.get_color(id)
	new_player.set_network_master(id)
	$players.add_child(new_player)
	new_player.position = spawnpoint
	rpc("create_player_client", id, spawnpoint)

puppet func create_player_client(id: int, pos: Vector2):
	var new_player: Node = player_scene.instance()
	var spawnpoint: Vector2 = pos
	new_player.name = str(id)
	new_player.color = Network.get_color(id)
	new_player.set_network_master(id)
	$players.add_child(new_player)
	new_player.position = spawnpoint

func handle_new_movement(pos: Vector2):
	movement_target.global_position = pos
	movement_target.show()

func stop_movement():
	movement_target.hide()

func spawn_soul():
	var new_soul: Node = soul_scene.instance()
	var spawnpoint: Vector2 = Vector2(rand_range(100, 924), rand_range(100, 500))
	new_soul.dir = new_soul.get_new_dir()
	add_child(new_soul)
	new_soul.global_position = spawnpoint
	rpc("receive_spawn_soul", spawnpoint, new_soul.dir)

puppet func receive_spawn_soul(pos: Vector2, dir: Vector2):
	var new_soul: Node = soul_scene.instance()
	var spawnpoint: Vector2 = pos
	new_soul.dir = dir
	add_child(new_soul)
	new_soul.global_position = spawnpoint

func _on_soul_spawn_timer_timeout():
	spawn_soul()
