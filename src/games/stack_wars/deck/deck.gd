extends RefCounted

class_name StackWars_Deck

var RNG: RandomNumberGenerator = RandomNumberGenerator.new()

var cards_in_deck: Array[StackWars_Card] = []
var cards_not_in_deck: Array[StackWars_Card] = []

func _init(cards: Array[StackWars_Card] = [], seed: int = 0):
	cards_in_deck = cards
	RNG.seed = seed
	RNG.state = 0

func pick_card() -> StackWars_Card:
	if len(cards_in_deck) <= 0 and len(cards_not_in_deck) <= 0:
		return null
	if len(cards_in_deck) <= 0:
		full_shuffle()
	
	var card: StackWars_Card = cards_in_deck.back()
	cards_in_deck.pop_back()
	return card

func return_card(card: StackWars_Card) -> void:
	cards_not_in_deck.append(card)

func full_shuffle():
	cards_in_deck.append_array(cards_not_in_deck)
	shuffle()

func shuffle():
	var cards: Array[StackWars_Card] = []
	var card: StackWars_Card
	while len(cards_in_deck) > 0:
		var index: int = RNG.randi_range(0, len(cards_in_deck))
		card = cards_in_deck[index]
		cards_in_deck.pop_at(index)
		cards.append(card)
