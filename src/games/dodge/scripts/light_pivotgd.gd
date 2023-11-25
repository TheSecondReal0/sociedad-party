extends Node3D

@export var speed: float = 10

func _process(delta):
	rotate_x(speed * delta)
	rotate_y(-speed * delta*.75)
	rotate_z(speed*delta*1.25)
