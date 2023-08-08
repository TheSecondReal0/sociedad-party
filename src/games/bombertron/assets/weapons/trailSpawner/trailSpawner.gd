extends Position2D

var speed = 50

var trail_scene: PackedScene = preload("res://games/bombertron/assets/weapons/trail/trail.tscn")

var player_owner: Node

var dir_vec: Vector2 = Vector2(1, 0)

var trail_delta: float = 0.0

var trail_range: int = 20

var trails_placed: int = 0

var color: Color = Color(1.0, 0.0, 0.0)

func _ready():
# warning-ignore:return_value_discarded
	Ticker.connect("tick", self, "_on_tronManager_move")
	$Polygon2D.color = color

func move():
	#print("moving in dir ", dir)
	var cell_size = 5 * 2
	position = roundPos()
	position += dir_vec * cell_size
	#print(global_rotation_degrees)
	if dir_vec == Vector2(1, 0):
		global_rotation_degrees = 0
	elif dir_vec == Vector2(-1, 0):
		global_rotation_degrees = 180
	elif dir_vec == Vector2(0, 1):
		global_rotation_degrees = 90
	elif dir_vec == Vector2(0, -1):
		global_rotation_degrees = -90

func create_trail(trail_coord: Vector2, trail_color: Color):
	var new_trail = trail_scene.instance()
	trail_coord = Vector2(stepify(trail_coord.x, 10), stepify(trail_coord.y, 10))
	new_trail.get_node("Sprite").modulate = trail_color
	new_trail.player_owner = self
	new_trail.global_position = trail_coord
	get_parent().get_parent().add_child(new_trail)
	
	#tronManager.death_coords.append(trail_coord)
	trails_placed += 1
	if trails_placed >= trail_range:
		queue_free()

func _on_tronManager_move():
	#print(dir_queue)
	move()
	position = roundPos()
	create_trail(global_position, color)

func roundPos(pos = position):
	return Vector2(stepify(pos.x, 10), stepify(pos.y, 10))
