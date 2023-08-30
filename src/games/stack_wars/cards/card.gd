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

var played_by_id: int = -1
var owner_id: int = -1
var target_id: int = -1
var stack_index: int = -1
var played_on_turn: int = -1

func _init(id: int, help: StackWars_Helper):
	owner_id = id
	helper = help
	play()

#called when a card is played to the stack
func play():
	pass

#called when a card resolves
func resolve():
	pass

#called when a card is removed from the stack
func remove():
	pass

#determines whether this card can be targeted by other cards on the stack
func is_targetable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !targetable:
		return false
	return true

#determines whether this card can be moved up and down the stack
func is_movable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !movable:
		return false
	
	return true

#determines whether this card can be removed from the stack
func is_removable(card: StackWars_Card) -> bool:
	if card != self:
		return true
	
	if !removable:
		return false
	return true

#determines whether this card can be played to the stack
func is_playable(card: StackWars_Card, player_id: int) -> bool:
	return true

#determines whether this card's turn constraint is met in order to be able to play it
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
