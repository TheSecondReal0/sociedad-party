extends Node2D

var player_scene: PackedScene = load("res://games/flash_ttt/assets/players/myPlayer/myPlayer.tscn")

puppet func deletePlayers():
	if has_node("players"):
		var node: Node2D = $players
		node.name = node.name + "deleting"
		node.queue_free()

func createPlayer(id):
	print("Creating player " + str(id))
	var newClient = player_scene.instance()
	newClient.set_name(str(id))
	newClient.playerName = Network.names[id]
	randomizePlayerPos(newClient)
	newClient.set_network_master(id)
	$players.add_child(newClient)

puppet func createPlayers():
	createPlayerNode()
	for id in Network.get_peers():
		createPlayer(id)

func randomizePlayerPos(playerNode):
	randomize()
	playerNode.position = Vector2(rand_range(100,2000), rand_range(100, 1000))

puppet func killPlayer(id):
	if get_node("players"):
		if get_node("players/" + str(id)):
			var player = get_node("players/" + str(id))
			player.killedBy("Death")

func createPlayerNode():
	var playerNode = Node2D.new()
	playerNode.name = "players"
	self.add_child(playerNode)
