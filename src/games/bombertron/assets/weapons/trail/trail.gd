extends StaticBody2D

var player_owner: Node

onready var tronManager: Node = get_parent()

func _ready():
	position = roundPos()
	tronManager.death_coords.append(global_position)
	tronManager.trail_nodes.append(self)

func destroy():
	#print(self, " getting destroyed")
	tronManager.death_coords.erase(global_position)
	tronManager.trail_nodes.erase(self)
	queue_free()

func roundPos(pos = position):
	return Vector2(stepify(pos.x, 10), stepify(pos.y, 10))
