extends Node2D

var player = load("res://games/bombertron/assets/players/tronBike/tronBike.tscn")

var playerNodes = []

var death_order: Array = []

var death_coords: Array = []
var trail_nodes: Array = []

func setup():
	resetGame()

func resetGame():
	$CanvasLayer/win_screen.hide()
	death_order.clear()
	#Ticker.update_tick_rate(0.07)
	rpc("resetGame")
	rpc("deletePlayers")
	deletePlayers()
	clear_trail()
	rpc("clear_trail")
	var player_array = get_tree().get_network_connected_peers()
	player_array.append(1)
	for i in player_array:#Network.clients:
		createPlayer(i)
	#for i in Network.clients:
		#rpc("createPlayer", i)

func player_died(id: int) -> void:
	print("player_died")
	death_order.append(id)
	var players_alive: Array = []
	for playerNode in playerNodes:
		if playerNode != null and is_instance_valid(playerNode):
			var curr_id: int = int(playerNode.name)
			if curr_id == id:
				continue
			players_alive.append(curr_id)
	if players_alive.size() == 1:
		show_win_screen(players_alive[0])
	elif players_alive.size() == 0:
		show_win_screen(0)

func show_win_screen(winner_id: int) -> void:
	$CanvasLayer/win_screen.show_winner(winner_id)

func createPlayer(id):
	print("creating player " + str(id))
	var newPlayer = player.instance()
	newPlayer.connect("died", self, "player_died")
	newPlayer.set_network_master(id)
	newPlayer.name = str(id)
	newPlayer.get_node("Polygon2D").color = Network.colors[id]
	#newPlayer.get_node("name").text = Network.names[str(id)]
	$players.add_child(newPlayer)
	var new_pos = Vector2(rand_range(124, 900), rand_range(100, 500))
	newPlayer.global_position = new_pos
	playerNodes.append(newPlayer)
	rpc("createPlayer", id, new_pos)

func deletePlayers():
	print("deleting players")
	death_coords = []
	trail_nodes = []
	for i in $players.get_children():
		i.name = str(i)
		playerNodes.erase(i)
		i.queue_free()

func clear_trail():
	for i in get_tree().get_nodes_in_group("trail"):
		i.queue_free()

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		resetGame()
