extends Button

onready var margin_container: MarginContainer = $MarginContainer
onready var texture_rect: TextureRect = $MarginContainer/VBoxContainer/TextureRect
onready var label: Label = $MarginContainer/VBoxContainer/Label

var tile_type: TileType

func _process(_delta):
	if visible:
		fix_sizing()

func init_button(type: TileType):
	tile_type = type
	texture_rect.texture = type.texture
	texture_rect.modulate = type.modulate
	label.text = type.type

func fix_sizing():
	rect_min_size = margin_container.rect_size
	margin_right = 0
	margin_right = margin_container.margin_right
