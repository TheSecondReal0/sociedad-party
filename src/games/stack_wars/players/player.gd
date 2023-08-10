extends RefCounted

class_name StackWars_Player

var helper: StackWars_Helper = null
var id: int = -1
var name: String = ""
var color: Color = Color()

var cards_on_stack: int = 0


func _init(playerID: int, help: StackWars_Helper):
	id = playerID
	helper = help
	color = Network.get_color(id)

func play_card(card: StackWars_Card, index: int = -1):
	helper.stack.add_card(card, index)

func can_end_turn() -> bool:
	return true

func end_turn():
	pass


