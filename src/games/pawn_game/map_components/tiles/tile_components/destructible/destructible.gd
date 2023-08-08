extends StaticBody2D

onready var player_id: int = get_parent().player_id

func damage(dmg: float):
	get_parent().damage(dmg)
