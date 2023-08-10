extends Resource

class_name StackWars_Card

var helper: StackWars_Helper = null

@export var title: String = "Default Title"
@export var description: String = "This is a sample description meant to test strings of certain length."
@export var turn_constraint: String = ">=2"
@export var targetable: bool = true
@export var movable: bool = true
@export var removable: bool = true

var played_by_id: int = 0
var owner_id: int = 0
var stack_index: int = -1


func _init(id: int, help: StackWars_Helper):
	owner_id = id
	helper = help
	play()

func play():
	pass

func resolve():
	pass

func remove():
	pass

func is_targetable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !targetable:
		return false
	return true

func is_movable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !movable:
		return false
	
	return true

func is_removable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !removable:
		return false
	return true

func is_playable(card: StackWars_Card, player_id: int) -> bool:
	return true
