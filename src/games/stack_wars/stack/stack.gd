extends RefCounted

class_name StackWars_Stack

var cards: Array[StackWars_Card] = []


func _init():
	pass

func add_card(card: StackWars_Card, index: int = -1):
	if index == -1:
		cards.append(card)

func remove_card(card: StackWars_Card):
	cards.erase(card)

func resolve_next_card():
	var card: StackWars_Card = cards.back()
	cards.pop_back()
	card.resolve()

func move_card(card: StackWars_Card, index: int):
	cards.erase(card)
	cards.insert(index, card)

func reverse():
	cards.reverse()
