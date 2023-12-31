extends Resource

class_name StackWars_Helper

static var stack: StackWars_Stack = StackWars_Stack.new(self)
static var players: Dictionary = {}
var main: StackWars_Main = null

var turn_num: int = 0
var current_turn_id: int = -1
var current_turn_player: StackWars_Player = null

#starting deck that each player gets
@export var starting_hand: Dictionary = {
	
}

func _init(m: StackWars_Main):
	main = m

#returns a player object given id
func get_player(id: int) -> StackWars_Player:
	if players.has(id):
		return players[id]
	else:
		return null

#increments the turn number and updates current player turn
func increment_turn() -> void:
	turn_num += 1
	current_turn_id = players.keys()[turn_num % len(players.keys())]
	current_turn_player = players[current_turn_id]
