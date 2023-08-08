extends Node

var roundOver = true

var roundReset = false

var resetting = false

var player_scene: PackedScene = load("res://games/flash_ttt/assets/players/myPlayer/myPlayer.tscn")

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self,  "client_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "client_disconnected")

func randomizePlayerPos(playerNode):
	randomize()
	playerNode.position = Vector2(rand_range(100,2000), rand_range(100, 1000))

func deletePlayers():
	if has_node("players"):
		var node: Node = $players
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

func createPlayers():
	createPlayerNode()
	for id in Network.get_peers():
		createPlayer(id)

func resetGame():
	resetting = true
	rpc("deletePlayers")
	deletePlayers()
	createPlayers()
	rpc("createPlayers")
	resetting = false

# warning-ignore:unused_argument
func _process(delta):
	if Input.is_action_just_pressed("restart"):
		resetGame()

func createPlayerNode():
	var playerNode = Node.new()
	playerNode.name = "players"
	add_child(playerNode)

func _on_Last_ready():
	$DeathCam.current = true
