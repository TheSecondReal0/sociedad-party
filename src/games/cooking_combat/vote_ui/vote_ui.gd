extends Control

var profile_scene: PackedScene = load("res://games/cooking_combat/vote_ui/profile_vote/profile_vote.tscn")

onready var grid: GridContainer = $GridContainer

var votes: Dictionary = {}

func _ready():
	for child in grid.get_children():
		child.queue_free()

func create_profiles(received_profiles: Dictionary):
	for player_id in received_profiles:
		create_profile(player_id, received_profiles)

func create_profile(player_id: int, received_profiles: Dictionary):
	var profile: Node = profile_scene.instance()
# warning-ignore:return_value_discarded
	profile.connect("voted_for", self, "profile_voted_for", [player_id])
	profile.name = str(player_id)
	grid.add_child(profile)
	profile.new_flavor_amounts(received_profiles[player_id])

func profile_voted_for(player_id: int):
	print("voted for ", player_id)
	rpc("receive_vote", player_id, Network.get_my_id())

remotesync func receive_vote(for_player: int, from_player: int):
	print("received vote for ", for_player, " from ", from_player)
	votes[from_player] = for_player
	print(votes)
	if has_everyone_voted():
		all_votes_received()

func all_votes_received():
	var votes_for_player: Dictionary = {}
	for voted in votes.values():
		if not voted in votes_for_player:
			votes_for_player[voted] = 0
		votes_for_player[voted] += 1
	var winner: int = votes_for_player.keys()[0]
	for player in votes_for_player:
		if votes_for_player[player] > votes_for_player[winner]:
			winner = player
	var winner_profile: Control = grid.get_node(str(winner))
	winner_profile.profile_won()

func has_everyone_voted() -> bool:
	for player in Network.get_peers():
		if not player in votes:
			return false
	return true
