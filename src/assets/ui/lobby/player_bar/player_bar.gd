extends PanelContainer

@export var label: Label
@export var rect: TextureRect

var player_id: int

func configure_player_bar(_player_id: int) -> void:
	player_id = _player_id
	update()

func update() -> void:
	label.text = Network.get_player_name(player_id)
	rect.self_modulate = Network.get_color(player_id)
