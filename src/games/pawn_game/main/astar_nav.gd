extends Node

export var navs_per_frame: int = 10

onready var map: Node2D = get_node("../pawn_game_map")

# {coordinate: astar id}
var coord_ids: Dictionary = {}

var astar: AStar2D = load("res://games/pawn_game/resources/astar/basic_astar/basic_astar.gd").new()#AStar2D.new()

var queued_pathing: Array = []

func _ready():
# warning-ignore:return_value_discarded
	#map.connect("tile_changed", self, "tile_changed")
# warning-ignore:return_value_discarded
	map.connect("walkable_tile_created", self, "walkable_tile_created")
# warning-ignore:return_value_discarded
	map.connect("walkable_tile_destroyed", self, "walkable_tile_destroyed")

# warning-ignore:unused_argument
func _process(delta):
	if queued_pathing.empty():
		return
	for _i in navs_per_frame:
		if queued_pathing.empty():
			break
		var inputs: Array = queued_pathing.pop_front()
		callv("direct_pawn_to", inputs)

# actually path should ONLY be true during _process() or _physics_process()
func direct_pawn_to(pawn: Node, pos: Vector2, actually_path: bool = false):
	if pawn == null or not is_instance_valid(pawn):
		return
	if not actually_path:
		print("trying to direct pawn outside of _process(), adding to queue")
		queued_pathing.append([pawn, pos, true])
		return
	#print("navving pawn to ", pos)
	var pawn_pos: Vector2 = pawn.global_position
	var path: PoolVector2Array = path(pawn_pos, pos)
	#print(path)
	pawn.path = path

func request_path_to(pos: Vector2, pawn: Node2D):
	queued_pathing.append([pawn, pos, true])

# NOT CALLED ANYMORE
# TRANSITIONED TO walkable_tile_created() AND walkable_tile_destroyed()
func tile_changed(coord: Vector2, old_type, new_type: String):
	var old_walkable: bool
	if old_type == null:
		old_walkable = false
	else:
		old_walkable = is_tile_type_walkable(old_type)
	var new_walkable: bool = is_tile_type_walkable(new_type)
	if old_walkable:
		remove_coord(coord)
	if new_walkable:
		add_coord(coord)

func walkable_tile_created(coord: Vector2, movement_cost: float):
	add_coord(coord, movement_cost)

func walkable_tile_destroyed(coord: Vector2):
	remove_coord(coord)

func path(start: Vector2, end: Vector2):
	var start_id: int = astar.get_closest_point(start)
	var end_id: int = astar.get_closest_point(end)
	var astar_path: PoolVector2Array = astar.get_point_path(start_id, end_id)
	if astar_path.empty():
		return astar_path
	if astar_path[-1] != end:
		astar_path.append(end)
#	create_line(astar_path)
	return astar_path

func add_coord(coord: Vector2, weight: float = 1.0):
	#print("adding coord ", coord)
	var id: int = astar.get_available_point_id()
	astar.add_point(id, coord, weight)
	coord_ids[coord] = id
	for pos in get_accessible_coords(coord):
		astar.connect_points(id, coord_ids[pos])

func remove_coord(coord: Vector2):
	if not coord in coord_ids:
		return
	var id: int = coord_ids[coord]
	astar.remove_point(id)
	var diag_pairs: Dictionary = get_adjacent_diag_pairs(coord)
	#print("diag pairs of ", coord, ": ", diag_pairs)
	for from_coord in diag_pairs:
		disconnect_coords(from_coord, diag_pairs[from_coord])
# warning-ignore:return_value_discarded
	coord_ids.erase(coord)

func connect_coords(from: Vector2, to: Vector2, bidirectional: bool = true):
	if not from in coord_ids or not to in coord_ids:
		return
	astar.connect_points(coord_ids[from], coord_ids[to], bidirectional)

func disconnect_coords(from: Vector2, to: Vector2):
#	if not from in coord_ids or not to in coord_ids:
#		return
	astar.disconnect_points(coord_ids[from], coord_ids[to])

func get_accessible_coords(coord: Vector2) -> Array:
	var coords: Array = get_adjacent_coords(coord, false)#[]
	var pairs: Dictionary = get_adjacent_diag_pairs(coord)
	for start_coord in pairs.keys():
		var current: Vector2 = coord
		var rel_start: Vector2 = start_coord - current
		var rel_end: Vector2 = pairs[start_coord] - current
		var diag: Vector2 = current + rel_start + rel_end
		if diag in coord_ids:
			coords.append(diag)
	return coords

func get_adjacent_diag_pairs(coord: Vector2) -> Dictionary:
	var adjacent_coords: Array = get_adjacent_coords(coord, false)
	var pairs: Dictionary = {}
	for pos in adjacent_coords:
		for vec in get_diagonal_coords(pos):
			if vec in adjacent_coords:
				if pos in pairs and pairs[pos] == vec:
					continue
				if vec in pairs and pairs[vec] == pos:
					continue
				pairs[pos] = vec
	return pairs

func get_adjacent_coords(coord: Vector2, diagonal: bool = true) -> Array:
	var coords: Array = []
	var factors: Array = [0, 1, -1]
	for x in factors:
		for y in factors:
			if x == 0 and y == 0:
				continue
			if not diagonal:
				if x != 0 and y != 0:
					continue
			var current: Vector2 = coord + (Vector2(x, y) * 20)
			if current in coord_ids:
				coords.append(current)
	return coords

func get_diagonal_coords(coord: Vector2) -> Array:
	var coords: Array = []
	var factors: Array = [1, -1]
	for x in factors:
		for y in factors:
			var current: Vector2 = coord + (Vector2(x, y) * 20)
			if current in coord_ids:
				coords.append(current)
	return coords

func is_tile_type_walkable(type: String):
	return map.is_tile_type_walkable(type)

func create_line(path: PoolVector2Array):
	var line: Line2D = Line2D.new()
	line.points = path
	add_child(line)
