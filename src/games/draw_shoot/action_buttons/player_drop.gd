extends PopupMenu

#var names: Dictionary = Network.names.duplicate()#{1: "one", 34534: "idk 34", 856: "8 hundred"}#
var id_name: Dictionary = {}

signal player_selected(id, player_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	update_dropdown()
# warning-ignore:return_value_discarded
#	names.erase(Network.get_my_id())
#	for id in names:
#		add_item(names[id], id)
#		id_name[id] = names[id]
#	#show()

func update_dropdown():
	var players_to_show: Array = get_parent().get_parent().get_parent().alive_players.duplicate()
	if Network.get_my_id() in players_to_show:
		players_to_show.erase(Network.get_my_id())
	for id in players_to_show:
		add_item(Network.names[id], id)
		id_name[id] = Network.names[id]

func _on_player_drop_id_pressed(id: int):
	print(id, ": ", id_name[id])
	emit_signal("player_selected", id, id_name[id])
	hide()
