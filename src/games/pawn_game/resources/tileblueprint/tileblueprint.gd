extends Resource

class_name TileBlueprint

export var blueprint_text: String
export(String, MULTILINE) var blueprint_desc: String
export var tile_type: Resource
export(Array, String) var buildable_on = ["Grass"]
export var work: int = 10
# resource name: amount needed
export var resource_cost: Dictionary = {
	"Gold": 0
}

var blueprint_node: Sprite
var preview_sprite: Sprite

func gen_blueprint() -> Sprite:
	if blueprint_node == null:
		blueprint_node = load("res://games/pawn_game/map_components/tiles/blueprint_bases/blueprint_base/blueprint_base.tscn").instance()
	return blueprint_node.duplicate() as Sprite

func gen_sprite() -> Sprite:
	if preview_sprite == null:
		var sprite: Sprite = tile_type.gen_sprite()
		sprite.modulate = Color(1, 1, 1, .5)
		sprite.material = load("res://games/pawn_game/common/shaders/greyscale_with_mod.tres")
		sprite.material.set("shader_param/modulate", tile_type.modulate)
		preview_sprite = sprite
	return preview_sprite.duplicate() as Sprite

func get_type() -> TileType:
	return tile_type as TileType
