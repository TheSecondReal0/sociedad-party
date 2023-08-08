extends Node2D

export (String, DIR) var tile_resource_dir = "res://games/pawn_game/map_components/tiles/tile_resources/"
export (String, DIR) var blueprint_resource_dir = "res://games/pawn_game/map_components/tiles/tile_blueprints/"
export var release_mode_enabled: bool = true

onready var world: Node2D = $pawn_game_world
onready var map: Node2D = world.get_node("pawn_game_map")
onready var pawn_controller: Node2D = world.get_node("pawn_controller")
onready var world_ui: Node2D = $world_ui
onready var pawn_game_ui: CanvasLayer = $pawn_game_ui
onready var editor: Control = pawn_game_ui.map_editor
onready var blueprint_ui: Control = pawn_game_ui.blueprint_ui

# storing how much of each resource we have
var resources: Dictionary = {"Gold": 0}

signal new_interactables(interactables)
signal tile_placed(pos, type)
signal preview_tiles(tile_coords, type)
signal blueprint_placed(pos, type)
signal preview_blueprints(tile_coords, type)
signal tile_created(tile)
signal interaction_selected(interaction, tile)
signal new_order(order)
signal box_selection_completed(start, end)
signal pawn_purchased
signal resource_updated(resource, value)
signal my_castle_created

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	world.connect("new_interactables", self, "new_interactables")
# warning-ignore:return_value_discarded
	map.connect("tile_created", self, "tile_created")
# warning-ignore:return_value_discarded
	world_ui.connect("box_selection_completed", self, "box_selection_completed")
# warning-ignore:return_value_discarded
	pawn_game_ui.connect("pawn_purchased", self, "pawn_purchased")
# warning-ignore:return_value_discarded
	pawn_game_ui.connect("interaction_selected", self, "interaction_selected")
# warning-ignore:return_value_discarded
	pawn_game_ui.connect("new_order", self, "new_order")
# warning-ignore:return_value_discarded
	editor.connect("tile_placed", self, "tile_placed")
# warning-ignore:return_value_discarded
	editor.connect("preview_tiles", self, "preview_tiles")
# warning-ignore:return_value_discarded
	blueprint_ui.connect("blueprint_placed", self, "blueprint_placed")
# warning-ignore:return_value_discarded
	blueprint_ui.connect("preview_blueprints", self, "preview_blueprints")
# warning-ignore:return_value_discarded
	pawn_controller.connect("my_castle_created", self, "my_castle_created")
#	map.load_default_json()

func tile_placed(pos, type):
	#print("main tile placed")
	emit_signal("tile_placed", pos, type)

func preview_tiles(tile_coords, type):
	emit_signal("preview_tiles", tile_coords, type)

func blueprint_placed(pos, type):
	emit_signal("blueprint_placed", pos, type)

func preview_blueprints(tile_coords, type):
	emit_signal("preview_blueprints", tile_coords, type)

func tile_created(tile):
	emit_signal("tile_created", tile)

func new_interactables(interactables: Dictionary):
	emit_signal("new_interactables", interactables)

func interaction_selected(interaction, tile):
	emit_signal("interaction_selected", interaction, tile)

func new_order(order: PawnOrder):
	emit_signal("new_order", order)

func box_selection_completed(start: Vector2, end: Vector2):
	emit_signal("box_selection_completed", start, end)

func pawn_purchased():
	emit_signal("pawn_purchased")

func my_castle_created():
	emit_signal("my_castle_created")

func update_resource(resource: String, amount: int):
	resources[resource] += amount
	emit_signal("resource_updated", resource, get_resource_amount(resource))

func get_resource_amount(resource: String) -> int:
	if not resource in resources:
		return 0
	return resources[resource]

func get_tile_resources():
	var _resources: Array = Helpers.load_files_in_dir_with_exts(tile_resource_dir, [".tres"])
	var res_dict: Dictionary = {}
	for res in _resources:
		res_dict[res.type] = res
	return res_dict

func get_blueprint_resources():
	var _resources: Array = Helpers.load_files_in_dir_with_exts(blueprint_resource_dir, [".tres"])
	var res_dict: Dictionary = {}
	for res in _resources:
		res_dict[res.blueprint_text] = res
	return res_dict

func round_pos(pos: Vector2, step: int = 20) -> Vector2:
	return Vector2(stepify(pos.x, step), stepify(pos.y, step))

func is_release_mode_enabled():
	return release_mode_enabled
