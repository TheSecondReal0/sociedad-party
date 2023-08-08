tool
extends Resource

class_name InteractUI

#name of the UI to open
export(String, FILE, "*.tscn") var ui_path
#data to pass to the UI node
export(Dictionary) var ui_data

enum actions {OPEN, UPDATE, CLOSE}
export(actions) var action = actions.OPEN

export(bool) var free_on_close = false

#changed in the editor via overriding get(), set(), and get_property_list()
#whether or not to delete and recreate the UI node before opening
var reinstance: bool = false

var only_instance: bool = false

var interact_data: Dictionary = {}

#called to execute the interaction this resource is customized for
func interact(_from: Node = null, _interact_data: Dictionary = {}):
	if only_instance:
		UIManager.instance_ui(ui_path, get_interact_data(_from, _interact_data))
		return
	match action:
		actions.OPEN:
			UIManager.open_ui(ui_path, get_interact_data(_from, _interact_data), reinstance)
		actions.CLOSE:
			UIManager.close_ui(ui_path, free_on_close)

func init_resource(_from: Node = null):
	pass

func get_interact_data(_from: Node = null, interact_data: Dictionary = {}) -> Dictionary:
	var reported_interact_data = interact_data
	for i in ui_data.keys():
		reported_interact_data[i] = ui_data[i]
	for i in interact_data.keys():
		reported_interact_data[i] = interact_data[i]
	reported_interact_data["interact"] = ui_path
	#print(reported_interact_data)
	return reported_interact_data

func _init():
	#ensures customizing this resource won't change other resources
	if Engine.editor_hint:
		#print("interactUI init")
		resource_local_to_scene = true

#EDITOR STUFF BELOW THIS POINT, DO NOT TOUCH UNLESS YOU KNOW WHAT YOU'RE DOING
#---------------------------------------------------------------------------------------------------
#overrides set(), allows for export var groups and display properties that don't
#match actual var names
func _set(property, value):
	match property:
		"advanced/reinstance":
			reinstance = value
		"advanced/only_instance":
			only_instance = value

#overrides get(), allows for export var groups and display properties that don't
#match actual var names
func _get(property):
	match property:
		"advanced/reinstance":
			return reinstance
		"advanced/only_instance":
			return only_instance

#overrides get_property_list(), tells editor to show more vars in inspector
func _get_property_list():
	#if not Engine.editor_hint:
	#	return []
	var property_list: Array = []
	property_list.append({"name": "advanced/reinstance",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_NONE,
		})
	property_list.append({"name": "advanced/only_instance",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_NONE,
		})
	return property_list
