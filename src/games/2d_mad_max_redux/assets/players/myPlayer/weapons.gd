extends Node2D

var harpoon = load("res://games/2d_mad_max_original/assets/weapons/harpoon/harpoon.tscn")

var activeWeap = harpoon

func _process(delta):
	#return
	if get_parent().is_network_master():
		if Input.is_action_just_pressed("ctrl"):
			fireHarpoon("forward", 0)#45)
		if Input.is_action_just_pressed("q"):
			fireHarpoon("left", 0)#-180)
		if Input.is_action_just_pressed("e"):
			fireHarpoon("right", 0)

func fireHarpoon(direction, angle):
	$harpoon.fire(direction, angle)
	rpc("remoteFire", direction, angle, not get_node("harpoon").hooked)

remote func remoteFire(direction, angle, hooked):
	$harpoon.remoteFire(direction, angle, hooked)
