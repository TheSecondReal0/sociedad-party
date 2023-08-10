extends RefCounted

class_name StackWars_Stack

var helper: StackWars_Helper = null

var cards: Array[StackWars_Card] = []


func _init(help: StackWars_Helper):
	helper = help

func add_card(card: StackWars_Card, index: int = -1):
	if index == -1:
		cards.append(card)
	else:
		cards.insert(index, card)
	index_cards()

func remove_card(card: StackWars_Card):
	cards.erase(card)
	index_cards()

func resolve_next_card():
	var card: StackWars_Card = cards.back()
	cards.pop_back()
	card.resolve()
	index_cards()

func move_card(card: StackWars_Card, index: int):
	cards.erase(card)
	cards.insert(index, card)
	index_cards()

func reverse():
	cards.reverse()
	index_cards()

func is_targetable(card: StackWars_Card) -> bool:
	for c in cards:
		if not c.is_targetable(card):
			return false
	return true

func is_movable(card: StackWars_Card) -> bool:
	for c in cards:
		if not c.is_movable(card):
			return false
	return true
	
	return true

func is_removable(card: StackWars_Card) -> bool:
	for c in cards:
		if not c.is_targetable(card):
			return false
	return true


func index_cards():
	var index: int = 0
	for card in cards:
		card.stack_index = index
		index += 1

