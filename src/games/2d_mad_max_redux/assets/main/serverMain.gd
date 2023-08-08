extends Node2D

var player = load("res://games/2d_mad_max_redux/assets/players/myPlayer/myPlayer.tscn")

var playerNodes = []

func resetGame():
	$map.updateMap()
	rpc("resetGame")
	rpc("deletePlayers")
	deletePlayers()
	for i in Network.clients:
		createPlayer(i)
	for i in Network.clients:
		rpc("createPlayer", i)

func createPlayer(id):
	print("creating player " + str(id))
	var newPlayer = player.instance()
	newPlayer.set_network_master(id)
	newPlayer.name = str(id)
	newPlayer.get_node("name").text = Network.get_player_name(id)
	newPlayer.set_network_master(id)
	$players.add_child(newPlayer)
	playerNodes.append(newPlayer)

func deletePlayers():
	print("deleting players")
	for i in $players.get_children():
		i.queue_free()

var newLine

func showGeneratedMapCoords(coordsArray, color):
	createNewLineNode(color)
	var currentPoint = 0
	#mapGenerator.pastCoords.size() - pointsToDraw
	for i in range(0, coordsArray.size() - 1):
		newLine.add_point(coordsArray[i])
		currentPoint += 1
		if newLine.points.size() > 1000:
			createNewLineNode(color)

func createNewLineNode(color):
	newLine = Line2D.new()
	newLine.default_color = color
	add_child(newLine)

func createWall(coordsArray, color):
	createNewPoly(color)
	var newCoordsArray = PoolVector2Array()
	for i in coordsArray:
		newCoordsArray.push_back(i)
	newPoly.polygon = newCoordsArray

func createNewTrackWallPolys(coordsArray, color):
	var pointsToCreate = coordsArray.size()
	var pointsCreated = 0
	var pointsPerWall = 10
	var cycles = round(pointsToCreate / (pointsPerWall * 2))
	var remainder = false
	if pointsToCreate / (pointsPerWall * 2) < cycles or cycles < 1:
		cycles -= 1
		remainder = true
	for i in cycles:
		var arraySlice = coordsArray.slice(-(pointsCreated / 2) - 1, -(pointsCreated / 2) - pointsPerWall - 1) + coordsArray.slice((pointsCreated / 2), pointsCreated + pointsPerWall)
		createWall(arraySlice, color)
		pointsCreated += pointsPerWall * 2
	if remainder:
		pointsPerWall = (pointsToCreate - pointsCreated) / 2
		var arraySlice = coordsArray.slice(-(pointsCreated / 2) - 1, -(pointsCreated / 2) - pointsPerWall - 1 + 1) + coordsArray.slice((pointsCreated / 2), pointsCreated + pointsPerWall)
		createWall(arraySlice, color)
		pointsCreated += pointsPerWall * 2

var newPoly

func createNewPoly(color):
	newPoly = Polygon2D.new()
	add_child(newPoly)
	newPoly.set_color(color)

func _ready():
	pass
	#createPlayer(1)
	#showGeneratedMapCoords(mapGenerator.pastCoords, Color(0.4, 0.5, 1))
	#showGeneratedMapCoords(mapGenerator.wall1Coords, Color(0, 1, 0))
	#createNewTrackWallPolys(mapGenerator.wall1Coords, Color(0, 0, 1))
	#showGeneratedMapCoords(mapGenerator.wall1Coords.slice(0, mapGenerator.wall1Coords.size() / 2 - 1))# + mapGenerator.wall1Coords.slice(-1, -301))
	#showGeneratedMapCoords(mapGenerator.wall2Coords.slice(0, 300) + mapGenerator.wall2Coords.slice(-1, -301))
	##createWall(mapGenerator.wall1Coords, Color(1, 0, 0))#.slice(0, 300) + mapGenerator.wall1Coords.slice(-1, -301))
	#createWall(mapGenerator.wall2Coords.slice(0, 300) + mapGenerator.wall2Coords.slice(-1, -301))
	#createWall([Vector2(-10, 10), Vector2(10, 10), Vector2(10, -10), Vector2(-10, -10)], Color(1, 1, 0))
	#createNewTrackWallPolys([Vector2(-5, 10), Vector2(15, 10), Vector2(25, 10), Vector2(25,-10), Vector2(15, -10), Vector2(-5, -10)], Color(0, 1, 1))

func _process(delta):
	if Input.is_action_just_pressed("restart"):
		resetGame()

