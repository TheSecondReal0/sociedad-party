extends Node2D

var wall = load("res://games/2d_mad_max_redux/assets/maps/procedural/wall.tscn")

var increment = 5

var mapGenerator_script: Script = load("res://games/2d_mad_max_redux/autoload/mapGenerator.gd")
var mapGenerator: Node = mapGenerator_script.new()

func _ready():
	print("procedural map loaded")
	mapGenerator.generateMapCoords()
	createRaceTrack(mapGenerator.pastCoords, mapGenerator.pastAngles)

func createRaceTrack(trackArray, angleArray):
	print("creating racetrack")
	for i in range(0, (trackArray.size() / increment) - 1):
		var currentCoord = trackArray[i * increment]
		var currentAngle = angleArray[i * increment]
		createWallsAtPosAngle(currentCoord, currentAngle)

func createWallsAtPosAngle(pos, angle):
	createWall(pos + (Vector2(cos(angle - (PI/2)), sin(angle - (PI/2))) * mapGenerator.trackRadius), angle)
	createWall(pos + (Vector2(cos(angle + (PI/2)), sin(angle + (PI/2))) * mapGenerator.trackRadius), angle)

func createWall(pos, angle):
	var newWall = wall.instance()
	newWall.position = pos
	newWall.rotation = angle
	add_child(newWall)
