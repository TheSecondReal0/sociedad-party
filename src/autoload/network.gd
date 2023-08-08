extends Node

const port = 6969

var server = false

var peer

var clients = []

var names = {}

var colors = {}

var myID = 0
var server_id: int
var rpc_sender_id: int

var myName = ""

var myColor: Color

var speed: int = 200

enum NET_PROTOCOLS {WEBSOCKET, UDP, DISCORD}
var net_protocol: int = NET_PROTOCOLS.UDP

enum RPC_INPUTS {FUNC_NAME, NODE_PATH, INPUTS, RPC_MODE, TARGET, SENDER}
enum RPC_MODES {RPC_MODE_REMOTE, RPC_MODE_MASTER, RPC_MODE_PUPPET, RPC_MODE_REMOTESYNC, RPC_MODE_MASTERSYNC, RPC_MODE_PUPPETSYNC}

# whether or not to allow object classes to be sent in RPC calls
# 	this means nodes, resources, etc.
var allow_object_decoding: bool = true

signal player_joined(network_id: int)
signal player_left(network_id: int)

signal player_data_updated(data)

signal reset

func host():
	emit_signal("reset")
	#mapGenerator.generateMapCoords(Vector2(512, 300), 0, 10000, 150, PI / 40, 5, 1)
	server = true
	clients = []
	#var multiplayer_api: MultiplayerAPI = MultiplayerAPI.new()
	match net_protocol:
		NET_PROTOCOLS.WEBSOCKET:
			peer = WebSocketMultiplayerPeer.new()
			#peer.listen(port, PackedStringArray(), true)
			peer.create_server(port)
			#multiplayer_api.multiplayer_peer = peer
			#get_tree().set_multiplayer(multiplayer_api)
			get_tree().get_multiplayer().multiplayer_peer = peer
			#get_tree().set_network_peer(peer)
			finish_configuring_server()
		NET_PROTOCOLS.UDP:
			peer = ENetMultiplayerPeer.new()
			peer.create_server(port, 100)
			#multiplayer_api.multiplayer_peer = peer
			#get_tree().set_multiplayer(multiplayer_api)
			get_tree().get_multiplayer().multiplayer_peer = peer
			finish_configuring_server()
			#print("finished configuring udp server")
		NET_PROTOCOLS.DISCORD:
			pass
			#DiscordMultiplayer.create_game()
# warning-ignore:return_value_discarded
#	get_tree().change_scene_to(load("res://main/main.tscn"))#load("res://games/cooking_combat/main/main.tscn"))
#	myID = 1
#	clients.append(1)
#	names[1] = myName
#	colors[1] = myColor
#	configure_object_decoding()
#	print("Server started")

func finish_configuring_server() -> void:
	#print("changing scene")
# warning-ignore:return_value_discarded
	#get_tree().call_deferred("change_scene_to_file", "res://main/main.tscn")
	#get_tree().change_scene_to_file("res://main/main.tscn")#load("res://games/cooking_combat/main/main.tscn"))
	switch_to_lobby_scene()
	#switch_to_main_scene()
	#print("changed scene")
	match net_protocol:
		NET_PROTOCOLS.DISCORD:
			pass
			#myID = DiscordMultiplayer.get_server_id()
	server = true
	myID = get_my_id()
	clients.append(get_my_id())
	names[get_my_id()] = myName
	colors[get_my_id()] = myColor
	configure_object_decoding()
	print("Server started")

func client(ip: String):
	#var multiplayer_api: MultiplayerAPI = MultiplayerAPI.new()
	match net_protocol:
		NET_PROTOCOLS.WEBSOCKET:
			peer = WebSocketMultiplayerPeer.new()
			var url: String
			if ":" in ip:
				url = ip
			else:
				url = "" + str(ip) + ":" + str(port) # You use "ws://" at the beginning of the address for WebSocket connections
			#var _error = peer.connect_to_url(url, PackedStringArray(), true)
			var _error = peer.create_client(url)
			#multiplayer_api.multiplayer_peer = peer
			#get_tree().set_multiplayer(multiplayer_api)
			get_tree().get_multiplayer().multiplayer_peer = peer
			#get_tree().set_network_peer(peer)
		NET_PROTOCOLS.UDP:
			peer = ENetMultiplayerPeer.new()
			peer.create_client(ip, port)
			#multiplayer_api.multiplayer_peer = peer
			#get_tree().set_multiplayer(multiplayer_api)
			get_tree().get_multiplayer().multiplayer_peer = peer
	finish_configuring_client()
	print("connecting to " + ip)

func finish_configuring_client() -> void:
	emit_signal("reset")
	server = false
	clients = []
	if net_protocol != NET_PROTOCOLS.DISCORD:
		set_multiplayer_authority(1)
	configure_object_decoding()

func leave():
	var network_peer: MultiplayerPeer = get_tree().multiplayer.multiplayer_peer
	if network_peer is ENetMultiplayerPeer:
		network_peer.close_connection()
	elif network_peer is WebSocketMultiplayerPeer:
		network_peer.close()
	elif network_peer is WebSocketMultiplayerPeer:
		network_peer.close()
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	emit_signal("reset")

func configure_object_decoding() -> void:
	get_tree().get_multiplayer().allow_object_decoding = allow_object_decoding

func custom_rpc(func_name: String, node: Node, inputs: Array, rpc_mode: int = RPC_MODES.RPC_MODE_REMOTE) -> void:
	var rpc_dict: Dictionary = create_rpc_dict(func_name, node, inputs, rpc_mode)
	#print("sending custom rpc: ", rpc_dict)
	send_rpc(rpc_dict)

func custom_rpc_id(target_id: int, func_name: String, node: Node, inputs: Array, rpc_mode: int = RPC_MODES.RPC_MODE_REMOTE) -> void:
	var rpc_dict: Dictionary = create_rpc_dict(func_name, node, inputs, rpc_mode)
	rpc_dict[RPC_INPUTS.TARGET] = target_id
	send_rpc(rpc_dict)

func send_rpc(rpc_dict: Dictionary) -> void:
	var rpc_dict_string: String = var_to_str(rpc_dict)
	match net_protocol:
		NET_PROTOCOLS.WEBSOCKET:
			rpc("receive_custom_rpc", rpc_dict_string)
		NET_PROTOCOLS.UDP:
			rpc("receive_custom_rpc", rpc_dict_string)
		NET_PROTOCOLS.DISCORD:
			pass
			#DiscordMultiplayer.send_rpc(rpc_dict_string)

func create_rpc_dict(func_name: String, node: Node, inputs: Array, rpc_mode: int = RPC_MODES.RPC_MODE_REMOTE) -> Dictionary:
	var dict: Dictionary = {}
	dict[RPC_INPUTS.FUNC_NAME] = func_name
	dict[RPC_INPUTS.NODE_PATH] = node.get_path()
	dict[RPC_INPUTS.INPUTS] = inputs
	dict[RPC_INPUTS.RPC_MODE] = rpc_mode
	dict[RPC_INPUTS.SENDER] = get_my_id()
	return dict

@rpc("any_peer", "call_local")
func receive_custom_rpc(rpc_dict_string: String) -> void:
	var rpc_dict: Dictionary = str_to_var(rpc_dict_string)
	if rpc_dict.keys().size() == 0:
		return
	#print("received custom rpc: ", rpc_dict)
	#print("received rpc from ", rpc_dict[RPC_INPUTS.SENDER])
	#print(rpc_dict)
	rpc_sender_id = rpc_dict[RPC_INPUTS.SENDER]
	if RPC_INPUTS.TARGET in rpc_dict:
		if get_my_id() != rpc_dict[RPC_INPUTS.TARGET]:
			return
	if not is_valid_sender(rpc_dict[RPC_INPUTS.SENDER], rpc_dict[RPC_INPUTS.RPC_MODE]):
		return
	#rpc_sender_id = rpc_dict[RPC_INPUTS.SENDER]
	var node: Node = get_node(rpc_dict[RPC_INPUTS.NODE_PATH])
	var func_name: String = rpc_dict[RPC_INPUTS.FUNC_NAME]
	var inputs: Array = rpc_dict[RPC_INPUTS.INPUTS]
	if node == null:
		return
		#assert(false, "RPC received for a node that doesn't exist")
	node.callv(func_name, inputs)

# function to see if we should accept an rpc/rset
func is_valid_sender(sender: int, rpc_mode: int) -> bool:
	var my_id: int = get_my_id()
	match rpc_mode:
		RPC_MODES.RPC_MODE_REMOTE:
			return get_my_id() != sender
		RPC_MODES.RPC_MODE_MASTER:
			return is_network_server()#my_id == network_master
		RPC_MODES.RPC_MODE_PUPPET:
			return not is_network_server()#my_id != network_master
		RPC_MODES.RPC_MODE_REMOTESYNC:
			return true
		RPC_MODES.RPC_MODE_MASTERSYNC:
			return is_network_server() or my_id == sender#my_id == network_master
		RPC_MODES.RPC_MODE_PUPPETSYNC:
			return not is_network_server() or my_id == sender
	return false

#puppet func sendName(id):
#	if not is_network_server():
#		custom_rpc("addName", self, [id, myName], MultiplayerAPI.RPC_MODE_MASTER)
		#rpc("addName", id, myName)

func sendName(my_name: String) -> void:
	custom_rpc("addName", self, [get_my_id(), my_name], RPC_MODES.RPC_MODE_MASTER)

func sendColor(color: Color) -> void:
	#print("sending color: ", color)
	custom_rpc("addColor", self, [get_my_id(), color], RPC_MODES.RPC_MODE_MASTER)

@rpc("any_peer")
func addName(id, playerName):
	id = get_rpc_sender_id()
#	if server:
#		var currentName = generatePlayerName(playerName, 0)
#		if currentName != playerName:
#			rset_id(id, "myName", currentName)
	names[id] = playerName
	#print(names)
	updateClientData()

@rpc("any_peer")
func addColor(id, color):
	#print(get_my_id(), " adding  color ", id, " ", color)
	id = get_rpc_sender_id()
	#print("adding color of player ", id, ", ", color)
	if not is_network_server():
		return
	colors[id] = color
	updateClientData()

#func generatePlayerName(oldName, addon):
#	if server:
#		var newName = ""
#		if addon != 0:
#			newName = oldName + str(addon)
#		else:
#			newName = oldName
#		if names.values().has(newName):
#			return generatePlayerName(oldName, addon + 1)
#		else:
#			print("sending new name: " + newName)
#			return newName

func updateClientData():
	if is_network_server():
		var data: Dictionary = {}
		data["clients"] = clients
		data["names"] = names
		data["colors"] = colors
		custom_rpc("receive_client_data", self, [data], RPC_MODES.RPC_MODE_PUPPET)
		receive_client_data(data)
		#rset("clients", clients)
		#rset("names", names)
		#rset("colors", colors)
		#mapGenerator.syncCoordsAngles()

@rpc func receive_client_data(data: Dictionary) -> void:
	#print(data)
	clients = data["clients"]
	names = data["names"]
	colors = data["colors"]
	if get_my_id() in names:
		myName = names[get_my_id()]
	if get_my_id() in colors:
		myColor = colors[get_my_id()]
	emit_signal("player_data_updated", data)

func _connected_ok():
	connected_to_server()

func connected_to_server():
	#print("start function connected to server")
	myID = get_my_id()
	names[get_my_id()] = myName
	if is_network_server():
		#print("stopping function connected to server, is network server")
		return
	
	#if net_protocol != NET_PROTOCOLS.DISCORD:
	custom_rpc("addName", self, [get_my_id(), get_my_name()])
	custom_rpc("addColor", self, [get_my_id(), get_my_color()])
	
# warning-ignore:return_value_discarded
	#get_tree().change_scene_to_file("res://main/main.tscn")#load("res://games/cooking_combat/main/main.tscn"))
	switch_to_lobby_scene()
	#switch_to_main_scene()
	
	emit_signal("reset")
	print("connected to server")

func _connection_failed() -> void:
	pass

func _player_connected(id):
	on_player_joined(id)

func on_player_joined(id: int):
	print("player connected: " + str(id))
	if is_network_server():
		clients.append(id)
		#rset_id(id, "myID", id)
		#rpc_id(id, "sendName", id)
		updateClientData()
	emit_signal("player_joined", id)

func _player_disconnected(id):
	on_player_left(id)

func on_player_left(id: int):
	print("player disconnected: " + str(id))
	if is_network_server():
		clients.erase(id)
		names.erase(id)
		colors.erase(id)
		updateClientData()
	emit_signal("player_left", id)

func _server_disconnected():
# warning-ignore:return_value_discarded
	get_tree().change_scene_to_file("res://ui/main_menu/main_menu.tscn")
	emit_signal("reset")

func is_server() -> bool:
	return is_network_server()

func is_network_server() -> bool:
	if net_protocol == NET_PROTOCOLS.DISCORD:
		pass
		#return DiscordMultiplayer.is_network_server()
	return get_tree().get_multiplayer().multiplayer_peer != null and get_tree().get_multiplayer().is_server()

func is_player_fully_joined(player_id: int) -> bool:
	return player_id in names and player_id in colors

func get_peers():
	return clients

func get_player_name(id: int) -> String:
	if not names.has(id):
		return "null"
	return names[id]

func get_player_names() -> Dictionary:
	return names

func get_my_name() -> String:
	return myName
	#get_player_name(get_my_id())

func get_color(id: int) -> Color:
	if not colors.has(id):
		return Color(1, 1, 1)
	return colors[id]

func get_colors() -> Dictionary:
	return colors

func get_my_color() -> Color:
	return myColor
	#return get_color(get_my_id())

func get_my_id() -> int:
	if net_protocol == NET_PROTOCOLS.DISCORD:
		pass
		#return DiscordMultiplayer.get_my_id()
	return get_tree().get_multiplayer().get_unique_id()#myID

func get_rpc_sender_id() -> int:
	if net_protocol == NET_PROTOCOLS.DISCORD:
		return rpc_sender_id
	return get_tree().get_multiplayer().get_remote_sender_id()

func get_server_id() -> int:
	if net_protocol == NET_PROTOCOLS.DISCORD:
		pass
		#return DiscordMultiplayer.get_server_id()
	return 1
	#return server_id

func connect_multiplayer_signals() -> void:
# warning-ignore:return_value_discarded
	get_tree().get_multiplayer().connect("peer_connected", _player_connected)
# warning-ignore:return_value_discarded
	get_tree().get_multiplayer().connect("peer_disconnected", _player_disconnected)
# warning-ignore:return_value_discarded
	get_tree().get_multiplayer().connect("connected_to_server", _connected_ok)
# warning-ignore:return_value_discarded
	get_tree().get_multiplayer().connect("connection_failed", _connection_failed)
# warning-ignore:return_value_discarded
	get_tree().get_multiplayer().connect("server_disconnected", _server_disconnected)

func switch_to_main_scene() -> void:
	get_tree().change_scene_to_file("res://main/main.tscn")
	#get_tree().change_scene_to_file("res://ui/lobby/lobby.tscn")

func switch_to_lobby_scene() -> void:
	switch_to_main_scene()
#	get_tree().change_scene_to_file("res://ui/lobby/lobby.tscn")

func _ready():
	randomize()
	# make it so when the game is paused, this script still runs
	process_mode = Node.PROCESS_MODE_ALWAYS
	#pause_mode = PAUSE_MODE_PROCESS
	connect_multiplayer_signals()

func _process(_delta):
	if net_protocol != NET_PROTOCOLS.WEBSOCKET:
		return
	if peer != null:
		if server:
			if peer.is_listening():
				peer.poll()
		elif (peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTED || peer.get_connection_status() == MultiplayerPeer.CONNECTION_CONNECTING):
			peer.poll()
