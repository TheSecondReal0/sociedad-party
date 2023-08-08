extends Area2D

onready var player_id: int = get_parent().player_id
onready var damage: int = get_parent().damage

func _physics_process(delta):
	var bodies: Array = get_overlapping_bodies()
	if bodies.empty():
		return
	for body in bodies:
		if not body.is_in_group("pawns"):
			return
		if body.player_id == player_id:
			return
		body.damage(calc_damage(delta))

func calc_damage(delta: float):
	return damage * delta
