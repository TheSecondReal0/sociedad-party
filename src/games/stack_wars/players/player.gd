extends RefCounted

class_name StackWars_Player

var helper: StackWars_Helper = null
var id: int = -1

func _init(playerID: int, help: StackWars_Helper):
	id = playerID
	helper = help
