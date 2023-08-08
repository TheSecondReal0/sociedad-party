extends Resource

class_name CoupCard

export(String) var name
export(Color) var color
export(String, MULTILINE) var desc
export(Array, Resource) var actions
export(Array, Resource) var blocks

func get_card_data() -> Dictionary:
	var data: Dictionary = {}
	for property in ["name", "color"]:
		data[property] = get(property)
	data["desc"] = gen_desc()
	data["actions"] = get_action_names()
	data["blocks"] = get_block_names()
	return data

func get_name() -> String:
	return name

func get_color() -> Color:
	return color

func get_desc() -> String:
	return gen_desc()

func gen_desc() -> String:
	var new_desc: String = desc
	new_desc = new_desc + "\n"
	new_desc = new_desc + "\nActions: " + get_names_as_string(get_action_names())
	new_desc = new_desc + "\nBlocks: " + get_names_as_string(get_block_names())
	return new_desc

func get_names_as_string(names: Array):
	var string: String = ""
# warning-ignore:shadowed_variable
	for name in names:
		if string != "":
			string = string + ", "
		string = string + name
# warning-ignore:return_value_discarded
	#string.replace("[", "").replace("]", "")
	return string

func get_action_names() -> Array:
	return get_names(get_action_resources())

func get_block_names() -> Array:
	return get_names(get_block_resources())

func get_names(resources: Array) -> Array:
	var names: Array = []
	for res in resources:
		names.append(res.get_name())
	return names

func get_action_resources() -> Array:
	return actions

func get_block_resources() -> Array:
	return blocks
