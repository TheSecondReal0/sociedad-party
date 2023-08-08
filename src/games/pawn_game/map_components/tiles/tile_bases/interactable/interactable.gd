extends Node2D

onready var area: Area2D = $Area2D

var tile_name: String
var desc: String
# whether or not a pawn can walk through this tile
var walkable: bool
# whether or not this tile is destructible
var destructible: bool
var health: int

# whether or not you can tell a pawn to interact with this tile
var interactable: bool
# what resource working this tile gives, leave blank for none
var resource: String

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	area.connect("input_event", self, "on_area_input_event")

func on_area_input_event(_viewport, event, _shape_index):
	if not event is InputEventMouseButton:
		return
	# doesn't actually change anything, just makes the text prediction stuff work
	event = event as InputEventMouseButton
	match event.button_index:
		BUTTON_LEFT:
			print("left")
			pass
		BUTTON_RIGHT:
			print("right")
			pass
