extends Node2D

onready var nav: Navigation2D = $Navigation2D
onready var line: Line2D = $Line2D
onready var pawns = $pawns

var start: Vector2 = Vector2(200, 50)
var end: Vector2 = Vector2(974, 550)

func _ready():
	direct_pawns_to(Vector2(rand_range(50, 974), rand_range(50, 550)), true)
#	end = Vector2(rand_range(50, 974), rand_range(50, 550))
#	for pawn in pawns.get_children():
#		#random()
#		start = pawn.global_position
#		var path: PoolVector2Array = path()
#		pawn.path = path

func _process(delta):
	input()
	return
	line_path()

func input() -> void:
	var mouse_pos: Vector2 = get_global_mouse_position()
	if Input.is_action_just_pressed("right_click"):
		print("right click, mouse pos: ", mouse_pos)
		direct_pawns_to(mouse_pos)#, true)
	#if Input.is_action_just_pressed("left_click"):
	#	print("left click, mouse pos: ", mouse_pos)
	#	direct_pawns_to(mouse_pos, true)#, true)
		#handle_new_movement(mouse_pos)

func direct_pawns_to(pos: Vector2, rand_start: bool = false):
	print("directing pawns to ", pos)
	if rand_start:
		rand_pawn_pos()
	for pawn in pawns.get_children():
		if pawn.selected:
			var pawn_pos: Vector2 = pawn.global_position
			var path: PoolVector2Array = path(pawn_pos, pos)
			pawn.path = path

func rand_pawn_pos():
	print("randomizing pawn locations")
	for pawn in pawns.get_children():
		pawn.global_position = Vector2(rand_range(50, 974), rand_range(50, 550))

func line_path(random: bool = true):
	if random:
		random()
	var path = path()
	line.points = path

func random_path() -> PoolVector2Array:
	random()
	return path()

func path(start_coord: Vector2 = start, end_coord: Vector2 = end)-> PoolVector2Array:
	#random()
	return nav.get_simple_path(start_coord, end_coord, true)
	#print(path)
	#line.points = path

func random():
	start = Vector2(rand_range(50, 974), rand_range(50, 550))
	end = Vector2(rand_range(50, 974), rand_range(50, 550))

func _on_Timer_timeout():
	return
	line_path()
