extends Control

class_name StackWars_Main

var helper: StackWars_Helper = StackWars_Helper.new(self)
var players: Dictionary = helper.players
var stack: StackWars_Stack = helper.stack

func _ready():
	pass

func setup(): #sets up game at first, creates players
	var ids = Network.clients
	for id in ids:
		var player: StackWars_Player = StackWars_Player.new(id, helper)
		players[id] = player

func start_game():
	pass

func end_turn(id: int):
	if id != helper.current_turn_id:
		return
	elif helper.current_turn_player.can_end_turn():
		helper.current_turn_player.end_turn()
		helper.increment_turn()

