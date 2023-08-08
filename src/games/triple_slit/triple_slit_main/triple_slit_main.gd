extends Control

var local_pressed_buttons: Array = []
var remote_pressed_buttons: Array = []

var info_dict: Dictionary = {}

var current_level: int = 0
var level_array: Array = Helpers.load_files_in_dir_with_exts("res://games/triple_slit/levels/", [".tres"])

var local_ready: bool = false
var remote_ready: bool = false

onready var level_desc: RichTextLabel = $level_desc
onready var info_display: VBoxContainer = get_node("VBoxContainer/info_display")
onready var submit_button: Button = get_node("VBoxContainer/Button")
onready var button_grid: GridContainer = $button_grid
onready var ready_button: Button = $ready_button
onready var timer: TextureProgress = $timer

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	button_grid.connect("button_pressed", self, "button_pressed")
# warning-ignore:return_value_discarded
	submit_button.connect("pressed", self, "submit_pressed")
# warning-ignore:return_value_discarded
	ready_button.connect("pressed", self, "ready_pressed")
# warning-ignore:return_value_discarded
	timer.connect("timer_complete", self, "timer_complete")
	host_level()

func host_level():
	var level_res: TripleSlitLevel = level_array[current_level]
	var level_info_dict: Dictionary = level_res.get_level_info_dict()
	var display: bool = [true, false][randi() % 2]
	setup_level(level_info_dict, display)
	rpc("setup_level", level_info_dict, not display)

puppet func setup_level(level_info_dict: Dictionary, display: bool):
	local_pressed_buttons.clear()
	remote_pressed_buttons.clear()
	level_desc.text = level_info_dict["desc"]
#	button_grid.hide()
	ready_button.show()
	timer.stop_timer()
	timer.reset_timer()
	local_ready = false
	remote_ready = false
	button_grid.create_buttons(level_info_dict["button_amount"])
	info_dict = level_info_dict["info_dict"]
	info_display.create_info_bars(info_dict, display)
	if display:
		submit_button.hide()
	else:
		submit_button.show()

puppetsync func start_level():
#	button_grid.show()
	ready_button.hide()
	timer.start_timer()
	info_display.show_info_values()

func ready_pressed():
	local_ready = true
	ready_button.hide()
	rpc("remote_ready_pressed")
	if both_ready():
		if is_network_master():
			rpc("start_level")

remote func remote_ready_pressed():
	remote_ready = true
	if both_ready():
		if is_network_master():
			rpc("start_level")

func both_ready() -> bool:
	return local_ready and remote_ready

func button_pressed(button_name: String):
	local_pressed_buttons.append(button_name)
	var remote_pressed: bool = is_button_remote_pressed(button_name)
	update_button(button_name, remote_pressed)
	if not remote_pressed:
		rpc("remote_button_pressed", button_name)

remote func remote_button_pressed(button_name: String):
	remote_pressed_buttons.append(button_name)

func is_button_remote_pressed(button_name: String) -> bool:
	return button_name in remote_pressed_buttons

func update_button(button_name: String, remote_pressed: bool):
	button_grid.get_node(button_name).update_button(remote_pressed)

func submit_pressed():
#	print("submit pressed")
	rpc_id(1, "check_values", get_input_dict())

func get_input_dict() -> Dictionary:
	return info_display.get_input_values()

remotesync func check_values(input_dict: Dictionary):
#	print("checking values")
	var mismatch: bool = false
	for info_name in input_dict:
#		print("checking ", input_dict[info_name], " against ", info_dict[info_name])
		if input_dict[info_name] != info_dict[info_name]:
			mismatch = true
			break
	if mismatch:
		print("level failed")
	else:
		print("level completed")
		current_level += 1
	if is_network_master():
		host_level()

func timer_complete():
	if is_network_master():
		host_level()
