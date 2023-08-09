extends RefCounted

class_name Card

var owner_id: int = 0
var stack_index: int = -1

func _init(id: int):
	owner_id = id
	

func play():
	pass

func resolve():
	pass



