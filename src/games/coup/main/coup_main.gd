extends CanvasLayer

export(int, 1, 5) var card_dupes = 3
export(int, 1, 5) var hand_size = 2
export(bool) var shuffle_after_challenge_reveal = false
export(Array) var action_order

onready var data_node = $coup_data
onready var ui_node = $coup_ui

var implied_card_res

var players: Array = Network.get_peers()
var alive_players: Array = []

var cards: Dictionary = {}
var cards_data: Dictionary = {}
var actions: Dictionary = {}
var actions_data: Dictionary = {}

var deck: Array = []
var hands: Dictionary = {}
var coins: Dictionary = {}

func setup():
	update_cards_actions_data()
	print("cards: ", cards)
	init_deck()
#	print("deck: ", deck)
	deal_cards()
	print("deck: ", deck)
	print("hands: ", hands)
	print("Steal blocked by ", blocked_by("Steal"))
	print("can Income be challenged? ", can_be_challenged("Income"))
	print("can Steal be challenged? ", can_be_challenged("Steal"))
	init_ui()

func deal_cards():
	players = [1,2,3,4,5,6]
	alive_players = players
	hands = {}
	for _i in hand_size:
		for p in players:
			deal_top(p)

func deal_top(player: int):
	deal(deck.pop_front(), player, true)

func deal(card: String, player: int, erased: bool = false):
	if not erased:
		deck.erase(card)
	if not hands.keys().has(player):
		hands[player] = []
	hands[player].append(card)

func init_deck():
	deck = []
	for card in cards.keys():
		for _i in card_dupes:
			deck.append(card)
	shuffle_deck()

func shuffle_deck():
	deck.shuffle()

func init_ui():
	ui_node.init_ui(cards_data, actions_data, hands, coins)

func update_cards_actions_data() -> void:
	var data: Dictionary = data_node.get_cards_actions_data()
	for property in data:
		set(property, data[property])

func can_be_challenged(action_name: String) -> bool:
	return actions_data[action_name].can_be_challenged

func blocked_by(action_name: String) -> Array:
	return actions_data[action_name].blocked_by
