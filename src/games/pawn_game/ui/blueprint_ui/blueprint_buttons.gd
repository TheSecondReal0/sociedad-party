extends HBoxContainer

signal blueprint_toggled(blueprint_res)

var button_scene: PackedScene = load("res://games/pawn_game/ui/common/buttons/tile_button/tile_button.tscn")

var blueprint_resources: Dictionary

func button_pressed(blueprint_text: String):
	emit_signal("blueprint_toggled", blueprint_text)

func create_buttons(new_blueprint_resources: Dictionary):
	blueprint_resources = new_blueprint_resources
	delete_all_buttons()
	for blueprint_text in blueprint_resources:
		create_button(blueprint_text)

func create_button(blueprint_text: String):
	var button: Button = button_scene.instance()
	button.name = blueprint_text
# warning-ignore:return_value_discarded
	button.connect("pressed", self, "button_pressed", [blueprint_text])
	add_child(button)
	button.init_button(blueprint_resources[blueprint_text].get_type())

func hide_button(blueprint_text: String):
	get_node(blueprint_text).hide()

func delete_button(blueprint_text: String):
	get_node(blueprint_text).queue_free()

func delete_all_buttons():
	for button in get_children():
		button.queue_free()
