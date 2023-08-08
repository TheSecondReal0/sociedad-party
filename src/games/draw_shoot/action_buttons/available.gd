extends HBoxContainer

var actions: Array = ["Draw", "Shoot", "Aim", "Stare", "Dodge", "Rush"]
var player_actions: Array = ["Shoot", "Stare", "Rush"]

var queued_player_action: String

onready var player_drop: PopupMenu = $player_drop

signal action_chosen(action)
signal player_action_chosen(action, player_id, player_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	create_buttons()

func button_pressed(action: String, button: Button):
	print("action chosen: ", action)
	player_drop.hide()
	if action in player_actions:
		queued_player_action = action
		if get_alive_players().size() > 2:
			show_dropdown(button)
			return
		else:
			var alive_players_exc_me: Array = get_alive_players().duplicate()
			alive_players_exc_me.erase(Network.get_my_id())
			var target: int = alive_players_exc_me[0]
			_on_player_drop_player_selected(target, Network.names[target])
		return
	emit_signal("action_chosen", action)

func new_round():
	if not Network.get_my_id() in get_alive_players():
		for button in get_children():
			if button is Button:
				button.disabled = true

# warning-ignore:unused_argument
func show_dropdown(button: Button):
	player_drop.rect_position = get_global_mouse_position()
	player_drop.show()

func create_buttons():
	print("creating buttons")
	for action in actions:
		create_button(action)

func create_button(action: String):
	#print("creating button: ", action)
	var button: Button = Button.new()
	button.text = action
	add_child(button)
# warning-ignore:return_value_discarded
	button.connect("pressed", self, "button_pressed", [action, button])

func get_alive_players() -> Array:
	return get_parent().get_parent().alive_players

# warning-ignore:unused_argument
func _on_player_drop_player_selected(id: int, player_name: String):
	print("player drop player selected: ", id, " ", player_name)
	emit_signal("player_action_chosen", queued_player_action, id, player_name)
