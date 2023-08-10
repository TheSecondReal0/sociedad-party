extends Node

class_name Stack

var cards: Array[Card] = []


func add_card(card: Card):
	cards.append(card)

func remove_card(card: Card):
	cards.erase(card)

func resolve_next_card():
	var card: Card = cards.back()
	cards.pop_back()
	card.resolve()

func reverse():
	cards.reverse()
