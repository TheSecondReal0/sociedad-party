extends HBoxContainer

#var display_value: bool

onready var info_name: Label = $info_name
onready var line_edit: LineEdit = $LineEdit
onready var info_value: Label = $info_value

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	#if display_value: info_value.show()

func show_info_value():
	if not line_edit.visible:
		info_value.show()

func init_info_bar(info_string: String, info_value_string: String, display_info: bool):
	info_name.text = info_string + ":"
	info_value.text = info_value_string
	if display_info:
		pass
#		info_value.show()
	else:
		line_edit.show()

func get_input_text() -> String:
	return line_edit.text
