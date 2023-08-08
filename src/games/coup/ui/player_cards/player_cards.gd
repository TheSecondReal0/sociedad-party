extends PanelContainer

onready var card_container: Node = $ScrollContainer/VBoxContainer
onready var main: Node = get_parent().get_parent()

var player_card_scene: PackedScene = load("res://games/coup/ui/player_cards/player_card/player_card.tscn")

var cards_data: Dictionary

var hands: Dictionary
var coins: Dictionary

func update_player_cards(new_cards_data: Dictionary, new_hands: Dictionary, new_coins: Dictionary):
	cards_data = new_cards_data
	hands = new_hands
	coins = new_coins
	create_player_cards()

func create_player_cards():
	for player_id in main.alive_players:
		create_player_card(player_id)

func create_player_card(player_id):
	var new_player_card: Node = player_card_scene.instance()
	new_player_card.name = str(player_id)
	card_container.add_child(new_player_card)
	new_player_card.init_player_card(cards_data, player_id, ["Contessa", "Duke"], 3)#hands[player_id], coins[player_id])
