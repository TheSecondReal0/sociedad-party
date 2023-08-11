extends Resource

class_name StackWars_Card

var helper: StackWars_Helper = null

@export var title: String = "Default Title"
@export var description: String = "This is a sample description meant to test strings of certain length."
enum TURN_CONSTRAINT_TYPES {NONE, EQUAL, LESS_EQUAL, GREATER_EQUAL}
@export var turn_constraint_type: TURN_CONSTRAINT_TYPES = TURN_CONSTRAINT_TYPES.NONE
@export var turn_constraint_num: int = 0
@export var targetable: bool = true
@export var movable: bool = true
@export var removable: bool = true

var played_by_id: int = 0
var owner_id: int = 0
var stack_index: int = -1
var played_on_turn: int = -1


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

func matches_turn_constraint(turn: int) -> bool:
	match turn_constraint_type:
		TURN_CONSTRAINT_TYPES.NONE:
			return true
		TURN_CONSTRAINT_TYPES.EQUAL:
			return turn == turn_constraint_num
		TURN_CONSTRAINT_TYPES.LESS_EQUAL:
			return turn <= turn_constraint_num
		TURN_CONSTRAINT_TYPES.GREATER_EQUAL:
			return turn >= turn_constraint_num
		_:
			assert(false, "Should not be reachable")
			return false
