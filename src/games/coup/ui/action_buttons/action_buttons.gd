extends PanelContainer

onready var grid: Node = $MarginContainer/GridContainer

var button_scene: PackedScene = load("res://games/coup/ui/action_buttons/action_button/action_button.tscn")

func update_actions(actions_data: Dictionary):
	create_buttons(actions_data)

func create_buttons(actions_data: Dictionary):
	for action_data in actions_data.values():
		create_button(action_data)

func create_button(action_data: Dictionary):
#	print("creating action button, action: ", action_data.name)
	var new_button: PanelContainer = button_scene.instance()
	new_button.name = action_data.name
# warning-ignore:return_value_discarded
	new_button.connect("action_used", self, "action_used")
# warning-ignore:return_value_discarded
	new_button.connect("action_used_on_player", self, "action_used_on_player")
	grid.add_child(new_button)
	new_button.init_button(action_data)

# warning-ignore:unused_argument
func action_used(action: String):
	pass

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func action_used_on_player(action: String, id: int):
	pass
