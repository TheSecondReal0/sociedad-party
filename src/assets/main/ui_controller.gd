extends CanvasLayer

var ui_list: Dictionary = UIManager.ui_list

var instanced_uis: Dictionary = {}
#nodes to ignore when updating instanced UIs
var ignored_ui_nodes: Array = ["ColorblindRect", "defaulthud"]

onready var config = ConfigFile.new()

func _ready():
	# make it so when the game is paused, this script still runs
	pause_mode = PAUSE_MODE_PROCESS
	set_network_master(1)
	UIManager.ui_controller_node = self
# warning-ignore:return_value_discarded
	UIManager.connect("open_ui", self, "open_ui")
# warning-ignore:return_value_discarded
	UIManager.connect("close_ui", self, "close_ui")
# warning-ignore:return_value_discarded
	UIManager.connect("instance_ui", self, "instance_ui")
# warning-ignore:return_value_discarded
	UIManager.connect("free_ui", self, "free_ui")

	#TODO: better system for auto spawning UIs
	instance_ui("chatbox")
	instance_ui("interactui")

#menu data is data to pass to the menu, such as a task identifier
#reinstance is whether or not to recreate the corresponding menu node if it already exists
func open_ui(ui_path: String, ui_data: Dictionary = {}, reinstance: bool = false):
	update_instanced_uis()
#	if not ui_list.keys().has(ui_name):
#		return
	if not file_exists(ui_path):
		return
	if reinstance or not instanced_uis.keys().has(remove_slashes(ui_path)):
		instance_ui(ui_path, ui_data)
	
	ui_path = remove_slashes(ui_path)
	
	if ui_data != {} and instanced_uis[ui_path].get("ui_data") != null:
		instanced_uis[ui_path].ui_data = ui_data
	var current_ui = get_ui(ui_path)
	#call open on a lower class, handles ui system integration
#	print(instanced_uis)
	if current_ui.has_method("base_open"):
		current_ui.base_open()
	#call open on the inherited class, most likely the script attached to a given task or menu
	if current_ui.has_method("open"):
		current_ui.open()
	move_child(current_ui, get_child_count() - 1)

func close_ui(ui_path: String, free: bool = false):
	ui_path = remove_slashes(ui_path)
	update_instanced_uis()
	if not instanced_uis.has(ui_path):
		return
	var current_ui = get_ui(ui_path)
	#call close on a lower class, handles ui system integration
	if current_ui.has_method("base_close"):
		current_ui.base_close()
	#call close on the inherited class, most likely the script attached to a given task or menu
	if current_ui.has_method("close"):
		current_ui.close()
	if free:
		free_ui(ui_path)

func instance_ui(ui_path: String, ui_data: Dictionary = {}):
	update_instanced_uis()
#	if not ui_list.keys().has(ui_name):
#		return
	if not file_exists(ui_path):
		return
	var new_ui = load(ui_path).instance()
	if ui_data != {} and new_ui.get("ui_data") != null:
		new_ui.ui_data = ui_data
	
	ui_path = remove_slashes(ui_path)
	
	new_ui.name = ui_path
	instanced_uis[ui_path] = new_ui
	add_child(new_ui)

func free_ui(ui_path: String):
	ui_path = remove_slashes(ui_path)
	var current_ui = get_ui(ui_path)
	if current_ui == null:
		return
	current_ui.queue_free()

func get_ui(ui_path: String):
	ui_path = remove_slashes(ui_path)
#	print("getting ui ", ui_path)
	update_instanced_uis()
	if not instanced_uis.has(ui_path):
		push_error("trying to get a ui node that doesn't exist")
		return null
	return instanced_uis[ui_path]

func update_instanced_uis() -> void:
	var child_nodes: Array = get_child_node_names()
	var temp_instanced_uis = instanced_uis.duplicate()
	for i in temp_instanced_uis.keys():
		if not child_nodes.has(i):
			temp_instanced_uis.erase(i)
			child_nodes.erase(i)
	for i in child_nodes:
		if ignored_ui_nodes.has(i) or temp_instanced_uis.has(i):
			continue
		push_error("UI element " + i + " instanced incorrectly, use instance_ui() instead")
		temp_instanced_uis[i] = get_node(i)
	instanced_uis = temp_instanced_uis

func get_child_node_names() -> Array:
	var name_list = []
	for i in get_children():
		name_list.append(i.name)
	return name_list

func file_exists(path: String):
	var file = File.new()
	return file.file_exists(path)

func remove_slashes(string: String):
	return string.replace("/", "").replace(".", "").replace(":", "")
