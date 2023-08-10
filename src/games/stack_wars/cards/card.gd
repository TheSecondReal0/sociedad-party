extends RefCounted

class_name Card

var title: String = "Super card deluxe"
var description: String = "This card will instantly make you win the game like super ez"
var turn_constraint: String = ">=2"

var owner_id: int = 0
var stack_index: int = -1

func _init(id: int):
	owner_id = id

func play():
	pass

func resolve():
	pass



