extends PanelContainer

onready var button: MenuButton = $MenuButton
onready var popup: PopupMenu = button.get_popup()
onready var panel: StyleBoxFlat = get("custom_styles/panel")#get_stylebox("panel")
onready var main: Node = get_parent().get_parent().get_parent().get_parent().get_parent()

var action: String = ""

var used_on_player: bool = true

signal action_used(action_name)
signal action_used_on_player(action_name, player_id)

func _ready():
# warning-ignore:return_value_discarded
	popup.connect("id_pressed", self, "_on_MenuButton_id_pressed")

func init_button(action_data: Dictionary):
	action = action_data.name
	set_panel_color(action_data.color)
	button.text = action
	button.hint_tooltip = action_data.desc
	used_on_player = action_data.used_on_player
	create_items(main.alive_players)

func create_items(player_ids: Array):
	popup.clear()
	for id in player_ids:
		var player_name = "Placeholder" + str(id)#Network.names[id]
		create_item(player_name, id)

func create_item(text: String, id: int):
	popup.add_item(text, id)

func set_panel_color(color: Color):
	var new_panel: StyleBoxFlat = load("res://games/coup/ui/action_buttons/action_button/action_button.tres").duplicate()
	new_panel.bg_color = color
	add_stylebox_override("panel", new_panel)
#	var panel = get_stylebox("panel")
#	panel.bg_color = color

func _on_MenuButton_id_pressed(id: int):
	emit_signal("action_used_on_player", action, id)

func _on_MenuButton_pressed():
	if not used_on_player:
		popup.hide()
	emit_signal("action_used", action)
