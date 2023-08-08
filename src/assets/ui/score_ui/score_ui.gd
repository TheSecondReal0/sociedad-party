extends VBoxContainer

func _ready():
# warning-ignore:return_value_discarded
	ScoreManager.connect("score_changed", self, "score_changed")

func open():
	update_ui()

func score_changed(scores: Dictionary):
	update_ui(scores)

func update_ui(scores: Dictionary = ScoreManager.get_scores()):
	clear_labels()
	for id in scores.keys():
		create_label(id, scores[id])

func clear_labels():
	for child in get_children():
		child.name += "deleting"
		child.hide()
		child.queue_free()

func create_label(player_id: int, score: int):
	var new_label = Label.new()
	new_label.name = str(player_id)
	new_label.text = gen_label_text(Network.get_player_name(player_id), score)
	add_child(new_label)

func gen_label_text(player_name: String, score: int) -> String:
	var text: String = player_name
	text += ": "
	text += str(score)
	return text
