extends RefCounted

class_name StackWars_Player

var helper: StackWars_Helper = null
var id: int = -1
var name: String = ""

var cards_on_stack: int = 0


func _init(playerID: int, help: StackWars_Helper):
	id = playerID
	helper = help

func play_card(card: StackWars_Card):
	
	pass

func can_end_turn() -> bool:
	return true

func end_turn():
	pass


