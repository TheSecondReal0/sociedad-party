extends Node2D

var player = preload("res://games/bombertron/assets/players/tronBike/tronBike.tscn")

var playerNodes = []

var death_order: Array = []

var death_coords: Array = []
var trail_nodes: Array = []

func _init():
	#Ticker.update_tick_rate(0.07)
	set_network_master(1)

puppet func resetGame() -> void:
	$CanvasLayer/win_screen.hide()
	death_order.clear()
	deletePlayers()
	clear_trail()

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

puppet func createPlayer(id, pos):
	var newPlayer = player.instance()
	newPlayer.connect("died", self, "player_died")
	newPlayer.set_network_master(id)
	newPlayer.name = str(id)
	newPlayer.get_node("Polygon2D").color = Network.colors[id]
	#newPlayer.get_node("name").text = Network.names[str(id)]
	$players.add_child(newPlayer)
	newPlayer.global_position = pos
	playerNodes.append(newPlayer)

puppet func deletePlayers():
	death_coords = []
	trail_nodes = []
	for i in $players.get_children():
		i.name = str(i)
		playerNodes.erase(i)
		i.queue_free()

puppet func clear_trail():
	for i in get_tree().get_nodes_in_group("trail"):
		i.queue_free()

func _ready():
	set_network_master(1)
