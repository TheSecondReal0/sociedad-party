extends PanelContainer

onready var name_label: Label = $MarginContainer/CenterContainer/name

var role: String = "Unknown"

func init_role_thing(card_data: Dictionary):
	name_label.text = card_data.name
	set_panel_color(card_data.color)
	set_tooltip(card_data.desc)

func set_panel_color(color: Color):
	var new_panel: StyleBoxFlat = load("res://games/coup/ui/common/role_thing/role_thing.tres").duplicate()
	new_panel.bg_color = color
	new_panel.draw_center = true
	if role != "Unkown":
		for dir in ["top", "left", "bottom", "right"]:
			new_panel.set("border_width_" + dir, 0)
	add_stylebox_override("panel", new_panel)
