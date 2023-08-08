extends HBoxContainer

signal ui_toggled(ui_name)

func _ready():
	for button in get_children():
		button.connect("pressed", self, "button_pressed", [button])
	if is_release_mode_enabled():
		get_node("map_editor").hide()

func button_pressed(button: Button):
	emit_signal("ui_toggled", button.name)

func is_release_mode_enabled():
	return get_parent().get_parent().is_release_mode_enabled()
