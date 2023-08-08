extends Node2D

#onready var classic_scene: PackedScene = load("res://games/2d_mad_max_original/assets/maps/classic/classic.tscn")
#onready var procedural_scene: PackedScene = load("res://games/2d_mad_max_original/assets/maps/procedural/procedural.tscn")

var maps = {"classic": load("res://games/2d_mad_max_original/assets/maps/classic/classic.tscn"), "procedural": load("res://games/2d_mad_max_original/assets/maps/procedural/procedural.tscn")}

func _ready():
	if not Network.server:
		set_network_master(1)

func updateMap():
	changeMap("classic")
	#changeMap("procedural")
	if Network.server:
		rpc("changeMap", "classic")
		#rpc("changeMap", "procedural")
	#for i in get_children():
	#	i.queue_free()

puppet func changeMap(newMap):
	for i in get_children():
		i.queue_free()
	add_child(maps[newMap].instance())
