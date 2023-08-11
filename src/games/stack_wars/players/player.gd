extends RefCounted

class_name StackWars_Player

var helper: StackWars_Helper = null
var id: int = -1
var name: String = ""
var color: Color = Color()

var played_cards_on_stack: Array[StackWars_Card] = []
var owned_cards_on_stack: Array[StackWars_Card] = []
var targeted_cards_on_stack: Array[StackWars_Card] = []
var cards_on_stack_num: int = 0


func _init(playerID: int, help: StackWars_Helper):
	id = playerID
	helper = help
	color = Network.get_color(id)

func play_card(card: StackWars_Card, index: int = -1):
	helper.stack.add_card(card, index)
	card.played_on_turn = helper.turn_num
	update_cards_on_stack()

func can_end_turn() -> bool:
	return true

func end_turn():
	pass

func update_cards_on_stack():
	played_cards_on_stack.clear()
	owned_cards_on_stack.clear()
	var cards: Array[StackWars_Card] = helper.stack.cards
	for card in cards:
		if card.owner_id == id:
			owned_cards_on_stack.append(card)
		if card.played_by_id == id:
			played_cards_on_stack.append(card)
		if card.target_id == id:
			targeted_cards_on_stack.append(card)

func reset():
	played_cards_on_stack.clear()
	owned_cards_on_stack.clear()
	cards_on_stack_num = 0
