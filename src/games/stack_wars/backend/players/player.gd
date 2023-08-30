extends RefCounted

class_name StackWars_Player

var helper: StackWars_Helper = null
var id: int = -1
var name: String = ""
var color: Color = Color()

var played_cards_on_stack: Array[StackWars_Card] = [] #cards that this player played onto the stack
var owned_cards_on_stack: Array[StackWars_Card] = [] #cards that this player controls on the stack
var targeted_cards_on_stack: Array[StackWars_Card] = [] #cards on the stack that this player is targeted by
var cards_on_stack_num: int = 0 #amount of cards that this player played on the stack


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

func update_cards_on_stack(): #check the stack and rebuild player specific card arrays
	played_cards_on_stack.clear()
	owned_cards_on_stack.clear()
	var cards: Array[StackWars_Card] = helper.stack.cards
	for card in cards:
		if card.owner_id == id:
			owned_cards_on_stack.append(card)
		if card.played_by_id == id:
			played_cards_on_stack.append(card)
			cards_on_stack_num += 1
		if card.target_id == id:
			targeted_cards_on_stack.append(card)

func reset(): #reset between stacks
	played_cards_on_stack.clear()
	owned_cards_on_stack.clear()
	cards_on_stack_num = 0
