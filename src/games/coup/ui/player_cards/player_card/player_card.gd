extends PanelContainer

onready var name_label: Label = $left/VBoxContainer/HBoxContainer/name
onready var coins_label: Label = $left/VBoxContainer/HBoxContainer/PanelContainer/coins
onready var role_thing_container: Node = $right/VBoxContainer

var role_thing_scene: PackedScene = load("res://games/coup/ui/common/role_thing/role_thing.tscn")

var cards_data: Dictionary

func init_player_card(new_cards_data: Dictionary, player_id: int, hand: Array = [], coins: int = 0):
	cards_data = new_cards_data
	name_label.text = "placeholder" + str(player_id)#Network.names[player_id]
	coins_label.text = "$" + str(coins)
	create_role_things(hand)

func update_player_card(hand: Array, coins: int):
	coins_label.text = "$" + str(coins)
	create_role_things(hand)

func create_role_things(hand: Array):
	for child in role_thing_container.get_children():
		child.name = child.name + "deleting"
		child.queue_free()
	for role in hand:
		create_role_thing(role)

func create_role_thing(role: String):
	var card_data: Dictionary = cards_data[role]
	var new_role_thing: Node = role_thing_scene.instance()
	new_role_thing.name = role
	role_thing_container.add_child(new_role_thing)
	new_role_thing.init_role_thing(card_data)
