extends Node

const port = 6969

var server = false

var peer

puppet var clients = []

puppet var names = {}

puppet var myID = 0

puppet var myName = ""

func host():
	#mapGenerator.generateMapCoords(Vector2(512, 300), 0, 10000, 150, PI / 40, 5, 1)
	server = true
	clients = []
	peer = WebSocketServer.new()
	peer.listen(port, PoolStringArray(), true)
	get_tree().set_network_peer(peer)
	#var peer = NetworkedMultiplayerENet.new()
	#peer.create_server(port, 100)
	#get_tree().network_peer = peer
	get_tree().change_scene_to(load("res://assets/main/serverMain.tscn"))
	clients.append(1)
	names[str(1)] = myName
	print("Server started")

func client(ip):
	server = false
	clients = []
	peer = WebSocketClient.new()
	var url = "" + str(ip) + ":" + str(port) # You use "ws://" at the beginning of the address for WebSocket connections
	var error = peer.connect_to_url(url, PoolStringArray(), true)
	get_tree().set_network_peer(peer)
	#var peer = NetworkedMultiplayerENet.new()
	#peer.create_client(ip, port)
	#get_tree().network_peer = peer
	set_network_master(1)
	print("connecting to " + ip)

remote func sendName(id):
	if not server:
		rpc("addName", id, myName)

remote func addName(id, playerName):
	if server:
		var currentName = generatePlayerName(playerName, 0)
		if currentName != playerName:
			rset_id(id, "myName", currentName)
		names[str(id)] = currentName
		print(str(names))
		updateClientData()

func generatePlayerName(oldName, addon):
	if server:
		var newName = ""
		if addon != 0:
			newName = oldName + str(addon)
		else:
			newName = oldName
		if names.values().has(newName):
			return generatePlayerName(oldName, addon + 1)
		else:
			print("sending new name: " + newName)
			return newName

func updateClientData():
	if server:
		rset("clients", clients)
		rset("names", names)
		mapGenerator.syncCoordsAngles()

func _connected_ok():
	if not server:
		get_tree().change_scene_to(load("res://assets/main/main.tscn"))
		rpc("addName", myID, myName)
		print("connected to server")

func _player_connected(id):
	print("player connected: " + str(id))
	if server:
		clients.append(id)
		rset_id(id, "myID", id)
		rpc_id(id, "sendName", id)
		updateClientData()
	
func _player_disconnected(id):
	print("player disconnected: " + str(id))
	if server:
		clients.erase(id)
		names.erase(str(id))
		updateClientData()

func _server_disconnected():
	get_tree().change_scene_to(load("res://assets/UI/mainMenu/mainMenu.tscn"))

func _ready():
	get_tree().connect("network_peer_connected", self, "_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_player_disconnected")
	get_tree().connect("connected_to_server", self, "_connected_ok")
	get_tree().connect("connection_failed", self, "_connected_fail")
	get_tree().connect("server_disconnected", self, "_server_disconnected")

func _process(delta):
	if peer != null:
		if server:
			if peer.is_listening():
				peer.poll()
		elif (peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTED || peer.get_connection_status() == NetworkedMultiplayerPeer.CONNECTION_CONNECTING):
			peer.poll()
