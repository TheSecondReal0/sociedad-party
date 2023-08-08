extends Control

onready var player_cards_node: Node = $player_cards
onready var actions_node: Node = $action_buttons

var cards_data: Dictionary
var actions_data: Dictionary
var hands: Dictionary
var coins: Dictionary

func init_ui(new_cards_data: Dictionary, new_actions_data: Dictionary, new_hands: Dictionary, new_coins: Dictionary):
	cards_data = new_cards_data
	actions_data = new_actions_data
	hands = new_hands
	coins = new_coins
	update_player_cards()
	update_actions()

func update_player_cards():
	player_cards_node.update_player_cards(cards_data, hands, coins)

func update_actions():
	actions_node.update_actions(actions_data)
