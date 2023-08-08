extends Node2D

var maps = {"classic": load("res://games/flash_ttt/assets/maps/classic/classic.tscn"), "classicMap": load("res://games/flash_ttt/assets/maps/classicMap/classicMap.tscn")}

func _ready():
	updateMap()

func updateMap():
	changeMap("classicMap")
	rpc("changeMap", "classicMap")
	#for i in get_children():
	#	i.queue_free()

puppet func changeMap(newMap):
	for i in get_children():
		i.queue_free()
	add_child(maps[newMap].instance())
