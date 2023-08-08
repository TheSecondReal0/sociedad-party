extends Node

puppet var scores: Dictionary = {}

signal score_changed(scores)

func _ready():
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_connected", self, "network_peer_connected")
# warning-ignore:return_value_discarded
	get_tree().connect("network_peer_disconnected", self, "network_peer_disconnected")

func network_peer_connected(id: int):
	set_score(id, 0)

func network_peer_disconnected(id: int):
# warning-ignore:return_value_discarded
	scores.erase(id)
	score_changed()

func reset_scores():
	scores = {}
	for peer in Network.get_peers():
		scores[peer] = 0
	score_changed()

func sync_scores():
	if not get_tree().is_network_server():
		return
	rset("scores", scores)

func update_score(player_id: int, diff: int):
	if not scores.has(player_id):
		return
	scores[player_id] += diff
	score_changed()

func set_score(player_id: int, score: int):
	scores[player_id] = score
	score_changed()

func score_changed(new_scores: Dictionary = scores):
	emit_signal("score_changed", new_scores)

func get_scores() -> Dictionary:
	return scores

func get_score(player_id: int) -> int:
	if not scores.has(player_id):
		return 0
	return scores[player_id]
