extends VBoxContainer

var info_dict: Dictionary = {}

var info_bar_scene: PackedScene = load("res://games/triple_slit/info_bar/info_bar.tscn")


func get_input_values() -> Dictionary:
	var input_dict: Dictionary = {}
	for info_name in info_dict:
		input_dict[info_name] = get_input_text(info_name)
	return input_dict

func show_info_values():
	for child in get_children():
		child.show_info_value()

func create_info_bars(info: Dictionary, display: bool):
	for child in get_children():
		child.name = child.name + "deleting"
		child.queue_free()
	info_dict = info
	for info_name in info:
		create_info_bar(info_name, info[info_name], display)

func create_info_bar(info_name: String, info_value: String, display: bool):
	var info_bar: HBoxContainer = info_bar_scene.instance()
	info_bar.name = info_name
	add_child(info_bar)
	info_bar.init_info_bar(info_name, info_value, display)

func get_input_text(info_name: String) -> String:
	return get_node(info_name).get_input_text()
