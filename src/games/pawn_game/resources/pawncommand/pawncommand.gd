extends Resource

class_name PawnCommand

# the order resource this command came from
var order: Resource
# the pawn this command is assigned to
var pawn: KinematicBody2D
var tileType

# where the pawn should go
var nav_target: Vector2
# where to look when pawn is done moving
# used so pawns can face the tile they're mining or whatever, could be used later
# 	to make pawns look somewhere if we implement view cones
var look_pos: Vector2

#func get_order() -> PawnOrder:
#	return order
