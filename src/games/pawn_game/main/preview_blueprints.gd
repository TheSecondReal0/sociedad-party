extends Node2D

export var main_path: NodePath

onready var main: Node2D = get_node(main_path)

var current_preview: TileBlueprint
var preview_blueprint_nodes: Dictionary = {}

func _ready():
# warning-ignore:return_value_discarded
	main.connect("preview_blueprints", self, "preview_blueprints")

func preview_blueprints(tile_coords: Array, type: TileBlueprint):
	current_preview = type
	#print(type)
	if type == null:
#		clear_pool_tiles()
		clear_preview_blueprints()
	preview_blueprints_from_array(tile_coords, type)

func preview_blueprints_from_array(array: Array, type: TileBlueprint):
	for coord in array:
		if not coord in preview_blueprint_nodes:
			preview_blueprint_nodes[coord] = preview_blueprint(coord, type)
	for coord in preview_blueprint_nodes:
		if not coord in array:
			preview_blueprint_nodes[coord].hide()
			preview_blueprint_nodes[coord].queue_free()
# warning-ignore:return_value_discarded
			preview_blueprint_nodes.erase(coord)

func preview_blueprint(coord: Vector2, type: TileBlueprint) -> Node:
	var blueprint: Sprite = type.gen_sprite()
	add_child(blueprint)
	blueprint.global_position = coord
	return blueprint

func clear_preview_blueprints():
	for node in preview_blueprint_nodes.values():
		node.queue_free()
	preview_blueprint_nodes.clear()
