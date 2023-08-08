extends Position2D

var dir_queue: Array

var coord: Vector2 = Vector2(0, 0)

enum facing {NORTH, EAST, SOUTH, WEST}

var dir_fails: Dictionary = {facing.NORTH: facing.SOUTH, facing.EAST: facing.WEST, facing.SOUTH: facing.NORTH, facing.WEST: facing.EAST}

puppet var direction: int

var dir_vec: Vector2 = Vector2(0, 0)

puppet var slave_direction: int

puppet var slave_position: Vector2 = Vector2(0, 0)

var speed: int = 200

var trail_scene: PackedScene = load("res://games/bombertron/assets/weapons/trail/trail.tscn")

var bomb_scene: PackedScene = load("res://games/bombertron/assets/weapons/trailSpawner/trailSpawner.tscn")

var destroyer_scene: PackedScene = load("res://games/bombertron/assets/weapons/trailDestroyer/trailDestroyer.tscn")

var trail_delta: float

var bomb_ammo: int = 5

var destroyer_ammo: int = 10

onready var tronManager: Node = get_parent().get_parent()

signal died

func _ready():
# warning-ignore:return_value_discarded
	Ticker.connect("tick", self, "_on_tronManager_move")

func _process(_delta):
	if global_position.x < 1 or global_position.x > 1019 or global_position.y < 1 or global_position.y > 599:
		die()
	
	if is_network_master():
		movement_input()
		rset_unreliable("direction", direction)
		rset_unreliable("slave_position", position)
	weapon_input()

puppet func place_bomb():
	if bomb_ammo <= 0:
		return
	print("placing bomb")
	bomb_ammo -= 1
	var used_dir_vec = dir_to_vec(direction + 1)
	var new_bomb = bomb_scene.instance()
	new_bomb.player_owner = self
	new_bomb.color = $Polygon2D.color
	get_parent().add_child(new_bomb)
	new_bomb.global_rotation_degrees = -90 + global_rotation_degrees
	new_bomb.global_position = global_position
	new_bomb.dir_vec = used_dir_vec
	
	new_bomb = bomb_scene.instance()
	new_bomb.player_owner = self
	new_bomb.color = $Polygon2D.color
	get_parent().add_child(new_bomb)
	new_bomb.global_rotation_degrees = 90 + global_rotation_degrees
	new_bomb.global_position = global_position
	new_bomb.dir_vec = used_dir_vec * -1

puppet func place_destroyer(pos: Vector2 = global_position, explode_next: bool = false):
	if destroyer_ammo <= 0:
		return
	destroyer_ammo -= 1
	var new_destroyer = destroyer_scene.instance()
	new_destroyer.player_owner = self
	new_destroyer.explode_next = explode_next
	get_parent().get_parent().add_child(new_destroyer)
	new_destroyer.global_position = pos

func dir_to_vec(dir):
	match dir % 4:
			0:
				return Vector2(0, -1)
			1:
				return Vector2(1, 0)
			2:
				return Vector2(0, 1)
			3:
				return Vector2(-1, 0)

func movement_input():
	var new_dir
	if Input.is_action_just_pressed("up"):
		new_dir = facing.NORTH
	if Input.is_action_just_pressed("left"):
		new_dir = facing.WEST
	if Input.is_action_just_pressed("down"):
		new_dir = facing.SOUTH
	if Input.is_action_just_pressed("right"):
		new_dir = facing.EAST
	if new_dir == null:
		return
	dir_queue.append(new_dir)

func weapon_input():
	if not is_network_master():
		return
	if Input.is_action_just_pressed("space"):
		rpc("place_bomb")
		place_bomb()
	if Input.is_action_just_pressed("left_shift"):
		rpc("place_destroyer", global_position)
		place_destroyer(global_position)

func move(dir: int):
	#print("moving in dir ", dir)
	var cell_size = 5 * 2
	position = Vector2(stepify(position.x, 10), stepify(position.y, 10))
	position += dir_to_vec(dir) * cell_size
	if is_network_master():
		rpc("receiveMove", dir)

puppet func receiveMove(dir: int):
	create_trail(global_position, $Polygon2D.color)
	move(dir)
	position = Vector2(stepify(position.x, 10), stepify(position.y, 10))

func change_direction(new_direction: int):
	if new_direction == direction:
		return
	if dir_fails[direction] == new_direction:
		return
	#print("changing direction to ", new_direction)
	direction = new_direction
	#rset("direction", direction)

func create_trail(trail_coord: Vector2, color: Color):
	var new_trail = trail_scene.instance()
	trail_coord = Vector2(stepify(trail_coord.x, 10), stepify(trail_coord.y, 10))
	new_trail.get_node("Sprite").modulate = color
	new_trail.player_owner = self
	new_trail.global_position = trail_coord
	get_parent().get_parent().add_child(new_trail)
	#tronManager.death_coords.append(trail_coord)

func die():
	print("dying")
	if not is_network_master():
		return
	emit_signal("died", int(name))
	rpc("receiveDeath")
	queue_free()

puppet func receiveDeath():
	print("received death")
	emit_signal("died", int(name))
	queue_free()

func _on_tronManager_move():
	if not is_network_master():
		return
	#print(dir_queue)
	if dir_queue.size() > 0:
		change_direction(dir_queue[0])
		dir_queue.remove(0)
	create_trail(global_position, $Polygon2D.color)
	move(direction)
	position = Vector2(stepify(position.x, 10), stepify(position.y, 10))
	if tronManager.death_coords.has(global_position):
		die()
	#create_trail(global_position, $Polygon2D.color)
