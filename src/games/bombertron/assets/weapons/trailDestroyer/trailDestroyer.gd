extends Area2D

var color_time: float

var explode_next: bool = false

var destroyer_scene = load("res://assets/weapons/trailDestroyer/trailDestroyer.tscn")

var player_owner: Node

var index_spot: int

var destroying_trails: bool = false
var trails: Array = []


onready var tronManager: Node = get_parent()

func _ready():
	index_spot = tronManager.death_coords.size()

func _process(delta):
	color_time += delta
	alternate_color()
	#for i in range(1, tronManager.death_coords.size() - index_spot):
	#	print(global_position.distance_to(tronManager.death_coords[-i]))
	if destroying_trails:
		for i in trails:
			#print("destroying ", i)
			i.destroy()
			queue_free()
	if not explode_next:
		return
	explode()
	explode_next = false

func _physics_process(_delta):
	pass

func explode():
	#print(get_overlapping_bodies())
	if tronManager.death_coords.size() < index_spot:
		index_spot = tronManager.death_coords.size() - 50
	
	index_spot -= get_overlapping_bodies().size()
	index_spot = 0
	for i in get_overlapping_bodies():
		if i.is_in_group("trail"):
			i.destroy()
	var trails_to_destroy: Array = []
	#for i in tronManager.death_coords.size():
	for i in range(1, tronManager.death_coords.size() - index_spot + 1):
		#print(global_position.distance_to(tronManager.death_coords[-i % tronManager.death_coords.size()]))
		if global_position.distance_to(tronManager.death_coords[-i % tronManager.death_coords.size()]) <= 50.0:# % tronManager.death_coords.size()
			#print("True")
			#print(tronManager.trail_nodes)
			trails_to_destroy.append(tronManager.trail_nodes[-i])

	trails = trails_to_destroy
	destroying_trails = true
	for i in trails_to_destroy:
		pass
		#print("destroying ", i)
		#i.destroy()
	#	var trail_color: Color = i.get_node("Sprite").modulate
	#	i.get_node("Sprite").modulate = trail_color.inverted()
#	queue_free()

func alternate_color():
	if not color_time > .1:
		return
	color_time = 0
	#print($Polygon2D.color)
	if $Polygon2D.color == Color(1, 1, 1):
		$Polygon2D.color = Color(1, 0, 0)
	else:
		$Polygon2D.color = Color(1, 1, 1)

func _on_Timer_timeout():
	#explode()
	explode_next = true
	#var parent = get_parent()
	#player_owner.place_destroyer(global_position, true)
	#queue_free()
