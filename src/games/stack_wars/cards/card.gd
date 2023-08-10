extends Resource

class_name Card

@export var title: String = "Default Title"
@export var description: String = "This is a sample description meant to test strings of certain length."
@export var turn_constraint: String = ">=2"
@export var targetable: bool = true
@export var movable: bool = true
@export var removable: bool = true

var played_by_id: int = 0
var owner_id: int = 0
var stack_index: int = -1

func _init(id: int):
	owner_id = id
	play()

func play():
	pass

func resolve():
	pass

func remove():
	pass

