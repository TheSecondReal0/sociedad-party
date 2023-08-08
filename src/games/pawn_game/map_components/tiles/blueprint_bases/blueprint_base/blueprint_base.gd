extends Sprite

var work_done: int = 0
var work_needed: int = 10

var blueprint_res: TileBlueprint
var tile_res: TileType

func _ready():
	var new_res: TileBlueprint = load("res://games/pawn_game/map_components/tiles/tile_blueprints/bridge.tres")
	init_blueprint(new_res)

func init_blueprint(new_blueprint_res: TileBlueprint):
	blueprint_res = new_blueprint_res
	tile_res = blueprint_res.tile_type
	texture = tile_res.texture
	scale = tile_res.scale
	#var color_vec4 = vec4()
	material.set("shader_param/modulate", tile_res.modulate)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
