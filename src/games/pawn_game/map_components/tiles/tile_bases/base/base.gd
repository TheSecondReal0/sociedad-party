extends Node2D

onready var interact_area = get_node_or_null("interact_area")
onready var navpoly = get_node_or_null("NavigationPolygonInstance")

var player_id: int

var type: String
var desc: String
# whether or not a pawn can walk through this tile
var walkable: bool
var pawn_on = false
# whether or not this tile is destructible
var destructible: bool
var max_health: float
var health: float = max_health
# whether or not to damage pawns
var damage_pawns: bool
var damage: int

# whether or not you can tell a pawn to interact with this tile
var interactable: bool
# what resource working this tile gives, leave blank for none
var resource: String

# list of available interactions
var orders: Array = []

signal interacted_with(tile_node, input)
signal tile_destroyed(tile_node)

func _ready():
	if interact_area:
		interact_area.connect("clicked", self, "on_clicked")
#	if navpoly:
#		var vertices = navpoly.navpoly.get_vertices()
#		var polygon: Polygon2D = Polygon2D.new()
#		polygon.polygon = vertices
#		add_child(polygon)

# warning-ignore:function_conflicts_variable
func damage(dmg: float):
	if not destructible:
		return
	if health == 0.0:
		return
	health -= dmg
	if health < 0.0:
		print("tile destroyed, ", global_position)
		emit_signal("tile_destroyed", self)
		health = 0.0

func init_tile(tile_data: Dictionary):
	#print(tile_data)
	for property in ["type", "desc", "walkable", "destructible", "health", "damage_pawns", "damage", "interactable", "resource", "orders"]:
		set(property, tile_data[property])
	max_health = tile_data["health"]
	health = max_health
	#print(interactions)

func on_clicked(input: InputEventMouseButton):
	# we want the ui to open on release
	if input.pressed:
		return
	match input.button_index:
		BUTTON_RIGHT:
			emit_signal("interacted_with", self, input)
			#print(input)

func get_orders():
	return orders
