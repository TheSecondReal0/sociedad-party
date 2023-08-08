extends Node2D

var player = load("res://games/2d_mad_max_original/assets/players/myPlayer/myPlayer.tscn")

var playerNodes = []

remote func resetGame():
	pass

slave func createPlayer(id):
	var newPlayer = player.instance()
	newPlayer.set_network_master(id)
	newPlayer.name = str(id)
	newPlayer.get_node("name").text = Network.names[str(id)]
	newPlayer.set_network_master(id)
	$players.add_child(newPlayer)
	playerNodes.append(newPlayer)

slave func deletePlayers():
	for i in $players.get_children():
		i.queue_free()

func _ready():
	set_network_master(1)
