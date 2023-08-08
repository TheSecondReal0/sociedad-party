extends Resource

class_name CoupAction

export(String) var name
export(Color) var color = Color(1, 1, 1)
export(String) var action_text
export(String, MULTILINE) var desc

export(bool) var used_on_player = false
export(bool) var shuffle_after = false
export(int) var coin_cost = 0
export(int) var free_coins = 0
export(int) var steal_coins = 0
export(int, 0, 5) var exchange_cards_picked
export(bool) var reveal_card = false

func get_action_data() -> Dictionary:
	var data: Dictionary = {}
	for property in ["name", "color", "action_text", "desc", "used_on_player", "shuffle_after", "coin_cost", "free_coins", "steal_coins", "exchange_cards_picked", "reveal_card"]:
		data[property] = get(property)
	return data

func get_name() -> String:
	return name

func get_color() -> Color:
	return color

func get_text() -> String:
	return action_text

func get_desc() -> String:
	return desc
