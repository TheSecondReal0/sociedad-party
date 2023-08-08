extends Node

export(String, DIR) var cards_dir
export(String, FILE, "*.tres") var implied_card
export(String, DIR) var actions_dir
export(Array, Resource) var action_order

onready var implied_card_res = load(implied_card)

var cards: Dictionary = {}
var cards_data: Dictionary = {}
var actions: Dictionary = {}
var actions_data: Dictionary = {}

func get_cards_actions_data() -> Dictionary:
	var data: Dictionary = {}
	update_cards_actions_data()
	for property in ["cards", "cards_data", "actions", "actions_data", "implied_card_res"]:
		data[property] = get(property)
	return data

func update_cards_actions_data():
	update_cards()
	update_cards_data()
	update_actions()
	update_actions_data()

func update_cards() -> void:
	cards = {}
	for res in get_card_resources():
		var res_name: String = res.get_name()
		cards[res_name] = res
	var implied_card_name: String = implied_card_res.get_name()
# warning-ignore:return_value_discarded
	cards.erase(implied_card_name)

func update_cards_data() -> void:
	cards_data = {}
	for value in cards.values():
		var res: CoupCard = value
		var data: Dictionary = res.get_card_data()
		var res_name: String = data.name
		cards_data[res_name] = data

func update_actions() -> void:
	actions = {}
	for res in get_action_resources():
		var res_name: String = res.get_name()
		actions[res_name] = res

func update_actions_data() -> void:
	actions_data = {}
	for value in actions.values():
		var res: CoupAction = value
		var data: Dictionary = res.get_action_data()
		var res_name: String = data.name
		data["can_be_challenged"] = can_be_challenged(res_name)
		data["blocked_by"] = blocked_by(res_name)
		actions_data[res_name] = data

func can_be_challenged(action_name: String) -> bool:
	for card_data in cards_data.values():
		if card_data.actions.has(action_name):
			return true
	return false

func blocked_by(action_name: String) -> Array:
	var blocked_by: Array = []
	for card_data in cards_data.values():
		if card_data.blocks.has(action_name):
			blocked_by.append(card_data.name)
	return blocked_by

func get_card_res_from_name(card_name: String):
	return cards[card_name]

func get_card_resources() -> Array:
	var resources = get_resources_from_dir(cards_dir)
#	print("card resources: ", resources)
	return resources

func get_action_res_from_name(action_name: String):
	return actions[action_name]

func get_action_resources() -> Array:
	var resources = get_resources_from_dir(actions_dir)
#	print("action resources: ", resources)
	return resources

func get_resources_from_dir(dir) -> Array:
	var paths = get_res_paths_in_dir(dir)
#	print(paths)
	return get_resources_from_paths(paths)

func get_resources_from_paths(paths: Array) -> Array:
	var resources: Array = []
	
	for path in paths:
		var resource = load(path)
		resources.append(resource)
	
	return resources

func get_res_paths_in_dir(directory) -> Array:
	var paths: Array = []
	var dir = Directory.new()
	dir.open(directory)
	dir.list_dir_begin()
	
	while true:
		var file = dir.get_next()
		if file == "":
			# completely break out of the loop
			break
		if not file.ends_with(".tres") or not file.ends_with("res"):
			# stop this iteration, but keep the loop going
			continue
		var path: String = directory + "/" + file
		paths.append(path)
	
	dir.list_dir_end()
	return paths
