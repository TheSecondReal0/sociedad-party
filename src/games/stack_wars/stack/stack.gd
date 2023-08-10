extends Node

class_name Stack

var cards: Array[Card] = []


func add_card(card: Card, index: int = -1):
	if index == -1:
		cards.append(card)

func remove_card(card: Card):
	cards.erase(card)

func resolve_next_card():
	var card: Card = cards.back()
	cards.pop_back()
	card.resolve()

func move_card(card: Card, index: int):
	cards.erase(card)
	cards.insert(index, card)

func reverse():
	cards.reverse()
