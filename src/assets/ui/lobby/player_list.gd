extends VBoxContainer

@export var other_players: Control
@export var player_bar_scene: PackedScene

@export var my_color: Control
@export var my_text: Control

# {id: bar}
var player_bars: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	#Network.connect("player_joined", player_joined)
	Network.connect("player_left", player_left)
	Network.connect("player_data_updated", player_data_updated)
	setup()



func player_data_updated(_data: Dictionary) -> void:
	update_my_player()
	for player_id in Network.get_peers():
		if player_id == Network.get_my_id():
			continue
		if not Network.is_player_fully_joined(player_id):
			continue
		if not player_id in player_bars:
			create_player_bar(player_id)
		else:
			player_bars[player_id].update()

func player_joined(id: int) -> void:
	create_player_bar(id)

func player_left(id: int) -> void:
	delete_player_bar(id)



func setup() -> void:
	update_my_player()
	create_other_players()

func update_my_player() -> void:
	my_color.color = Network.get_my_color()
	var caret: int = my_text.get_caret_column()
	my_text.text = Network.get_my_name()
	my_text.set_caret_column(caret)

func create_other_players() -> void:
	for player_id in Network.get_peers():
		# our player info is displayed separately
		if player_id == Network.get_my_id():
			continue
		create_player_bar(player_id)

func create_player_bar(player_id: int) -> void:
	var bar: Control = player_bar_scene.instantiate()
	bar.configure_player_bar(player_id)
	bar.name = str(player_id)
	other_players.add_child(bar)
	player_bars[player_id] = bar

func delete_player_bar(player_id: int) -> void:
	player_bars[player_id].queue_free()
	player_bars.erase(player_id)



func _on_color_picker_button_color_changed(color: Color):
	#print("color changed")
	Network.sendColor(color)

func _on_line_edit_text_changed(new_text: String):
	Network.sendName(new_text)
