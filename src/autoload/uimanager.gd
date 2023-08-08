extends Node

var filepath = ("user://settings.cfg")
var configfile
var keybinds = {}

var ui_list: Dictionary = {
						#HUD
						}

var current_ui: Control

var open_uis: Array = []

var just_closed: String = ""

var interact_ui_node: Node

var ui_controller_node: Node

signal open_ui(ui_name, ui_data, reinstance)
signal close_ui(ui_name, free)
signal instance_ui(ui_name, ui_data)
signal free_ui(ui_name)

func _ready():
	# make it so when the game is paused, this script still runs
	pause_mode = PAUSE_MODE_PROCESS
	pass

#ui data is data to pass to the ui, such as a task identifier
#reinstance is whether or not to recreate the corresponding ui node if it already exists
func open_ui(ui_path: String, ui_data: Dictionary = {}, reinstance: bool = false):
	#print("signalling to open ", menuName)
#	if not ui_list.keys().has(ui_name):
#		push_error("open_ui() called with invalid ui name " + ui_name)
	emit_signal("open_ui", ui_path, ui_data, reinstance)

func close_ui(ui_path: String, free: bool = false):
#	if not ui_list.keys().has(ui_name):
#		push_error("close_ui() called with invalid ui name " + ui_name)
	emit_signal("close_ui", ui_path, free)

func instance_ui(ui_path: String, ui_data: Dictionary = {}):
#	print("instance ui ", ui_path)
#	if not ui_list.keys().has(ui_name):
#		push_error("instance_ui() called with invalid ui name " + ui_name)
	emit_signal("instance_ui", ui_path, ui_data)

func free_ui(ui_path: String):
#	if not ui_list.keys().has(ui_name):
#		push_error("free_ui() called with invalid ui name " + ui_name)
	emit_signal("free_ui", ui_path)

func get_ui(ui_path: String):
#	if not ui_list.keys().has(ui_name):
#		push_error("get_ui() called with invalid ui name " + ui_name)
	if ui_controller_node == null:
		push_error("ui_controller_node is null (not set) in UIManager, should be set when the ui controller is created")
		return null
	return ui_controller_node.get_ui(ui_path)

func ui_opened(menuName):
	if open_uis.has(menuName):
		return
	open_uis.append(menuName)
	current_ui = get_ui(menuName)

func ui_closed(menuName):
	open_uis.erase(menuName)
	just_closed = menuName
	if not open_uis.empty():
		current_ui = get_ui(open_uis[-1])

# warning-ignore:unused_argument
# warning-ignore:unused_argument
func state_changed(old_state, new_state):
#	if new_state == GameManager.State.Normal:
#		pass
#	if new_state == GameManager.State.Start:
#		open_uis = []
	pass

func in_ui() -> bool:
	return not open_uis.empty()

func get_interact_ui_node():
	return interact_ui_node

func _process(_delta):
	just_closed = ""

func _input(event: InputEvent) -> void:
	#if ui_cancel (most likely esc) and not in menu, open pause menu
	if event.is_action_pressed("ui_cancel") and not in_ui() and just_closed != "pausemenu":
		open_ui("pausemenu")
		ui_opened("pausemenu")
