extends Node2D

onready var astar_nav: Node = $astar_nav
onready var map: Node2D = $pawn_game_map

signal new_interactables(interactables)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _unhandled_input(event: InputEvent):
	if not event is InputEventMouseButton:
		return
	# doesn't actually change anything, just makes the text prediction stuff work
	event = event as InputEventMouseButton
	if event.pressed:
		return
	match event.button_index:
		BUTTON_LEFT:
			pass
		BUTTON_RIGHT:
			#print("world right")
			get_tree().set_input_as_handled()
			event = make_input_local(event)
			_on_right_click(event)
			pass

func _on_right_click(event: InputEventMouseButton):
	#print(event.position)
	#print(event.global_position)
	var interactables: Dictionary = get_interactables(event.position)
	if are_no_interactables(interactables):
		return
	interactables["input_event"] = event
	emit_signal("new_interactables", interactables)

# NOT USED
# warning-ignore:unused_argument
func get_interactions(coord: Vector2):
	var interactions: Dictionary = {}
	
	#interactions["tiles"]
	
	return interactions

func get_interactables(coord: Vector2):
	var interactables: Dictionary = {}
	interactables["tiles"] = map.get_interactables_at(coord)
	return interactables

func are_no_interactables(interactables: Dictionary):
	for key in interactables:
		if not interactables[key].empty():
			return false
	return true
