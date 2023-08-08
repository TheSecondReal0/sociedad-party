extends Control

@export var vote_button: Button

var votes: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Network.connect("player_joined", player_joined)
	Network.connect("player_left", player_left)
	#vote_button.connect("pressed", vote_button_pressed)
	vote_button.connect("toggled", vote_button_toggled)
	setup()

func setup() -> void:
	reset_votes()
	votes_updated()

@rpc("call_local")
func start_game() -> void:
	reset_votes()
	Network.switch_to_main_scene()

func should_start_game() -> bool:
	var amount_ready: int = 0
	for value in votes.values():
		if value:
			amount_ready += 1
	return amount_ready != 0 and amount_ready == votes.size()

func vote_button_toggled(pressed: bool) -> void:
	vote_changed(pressed)

@warning_ignore("shadowed_variable_base_class")
func vote_changed(ready: bool, id: int = Network.get_my_id()):
	if not Network.is_network_server():
		send_vote(ready)
		return
	votes[id] = ready
	send_player_votes()
	votes_updated()
	if should_start_game():
		Network.custom_rpc("start_game", self, [], Network.RPC_MODES.RPC_MODE_PUPPETSYNC)

@warning_ignore("shadowed_variable_base_class")
func send_vote(ready: bool) -> void:
	Network.custom_rpc("receive_player_vote", self, [ready])

@rpc("any_peer")
@warning_ignore("shadowed_variable_base_class")
func receive_player_vote(ready: bool) -> void:
	if not Network.is_network_server():
		return
	var id: int = Network.get_rpc_sender_id()
	vote_changed(ready, id)

func send_player_votes() -> void:
	Network.custom_rpc("receive_player_votes", self, [votes], Network.RPC_MODES.RPC_MODE_PUPPETSYNC)

@rpc
func receive_player_votes(new_votes: Dictionary) -> void:
	votes = new_votes
	if should_start_game():
		start_game()
	votes_updated()

func player_joined(id: int) -> void:
	votes[id] = false
	send_player_votes()
	votes_updated()

func player_left(id: int) -> void:
	votes.erase(id)
	send_player_votes()
	votes_updated()

func votes_updated() -> void:
	var local_ready: bool = votes.get(Network.get_my_id(), false)
	var amount_ready: int = 0
	for value in votes.values():
		if value:
			amount_ready += 1
	var text: String
	if local_ready:
		text = "Ready!"
	else:
		text = "Not ready"
	text += " (" + str(amount_ready) + "/" + str(votes.size()) + ")"
	vote_button.text = text

func reset_votes() -> void:
	votes.clear()
	for id in Network.get_peers():
		votes[id] = false
