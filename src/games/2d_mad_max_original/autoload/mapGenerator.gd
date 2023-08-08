extends Node

var generatedMapCoords

var currentCoords = Vector2()

var currentAngle = 0

var lengthGenerated = 0

remote var pastCoords = []

remote var pastAngles = []

var wall1Coords = []

var wall2Coords = []

var smoothedCenterCoords = []

var pixelsToCorner = 0

var safeDistanceBetweenCenters = 100

var smoothingStrength = 5

remote var trackRadius = 0

func syncCoordsAngles():
	rset("pastCoords", pastCoords)
	rset("pastAngles", pastAngles)
	rset("trackRadius", trackRadius)

#generateMapCoords(Vector2(512, 300), 0, 10000, 150, PI / 40, 5, 1) #for some reason the wall is only drawn if radius - thickness < 12
func generateMapCoords(startCoords = Vector2(512, 300), startAngle = 0, length = 10000, radius = 150, turnRate = PI / 40, thickness = 5, resolution = 1):
	trackRadius = radius
	currentCoords = startCoords
	currentAngle = startAngle
	lengthGenerated = 0
	pastCoords = []
	wall1Coords = []
	wall2Coords = []
	pixelsToCorner = (PI/2) / turnRate
	safeDistanceBetweenCenters = (2 * radius) + (2 * pixelsToCorner)
	randomize()
	createCenterCoordsHere()
	for i in length / resolution:
		moveCenter(length, turnRate, resolution)
		#currentAngle += rand_range(-turnRate, turnRate) * resolution
		#currentCoords += Vector2(cos(currentAngle), sin(currentAngle)) * resolution
		lengthGenerated += resolution
	smoothCenterCoords()
	createWallCoords(pastCoords, pastAngles, radius, thickness)

func moveCenter(length, turnRate, resolution):
	var newSafePoint = findNewSafePoint(length, turnRate, resolution)
	currentAngle = newSafePoint[0]
	currentCoords = newSafePoint[1]
	createCenterCoordsHere()

func findNewSafePoint(length, turnRate, resolution):
	var testAngle = currentAngle + rand_range(-turnRate, turnRate) * resolution
	var testCoord = currentCoords + Vector2(cos(currentAngle), sin(currentAngle)) * resolution
	if checkIfSafe(testCoord, testAngle):
		return [testAngle, testCoord]
	else:
		return findNewSafePoint(length, turnRate, resolution)

func checkIfSafe(newPoint, newAngle):
	var testPoint = newPoint + (Vector2(cos(newAngle), sin(newAngle)) * ((safeDistanceBetweenCenters / 2)))
	var distanceToTest = []
	for i in pastCoords:
		distanceToTest.append(testPoint.distance_to(i))
	for i in distanceToTest:
		if i < safeDistanceBetweenCenters / 2:
			return false
	return true

func createCenterCoordsHere():
	pastCoords.append(currentCoords)
	pastAngles.append(currentAngle)

func smoothCenterCoords():
	smoothedCenterCoords = []
	for i in range(0, pastCoords.size() - 1):
		var newSmoothedCoord = Vector2()
		if i < smoothingStrength:
			pass
			#print("not enough values to smooth")
		elif pastCoords.size() - 1 - i < smoothingStrength:
			#print("not enough values to smooth")
			for p in range(1, pastCoords.size() - 1 - i):
				newSmoothedCoord += pastCoords[i - p]
				newSmoothedCoord += pastCoords[i + p]
				newSmoothedCoord = newSmoothedCoord / 2 * (range(1, i).size())
		else:
			for p in smoothingStrength:
				newSmoothedCoord += pastCoords[i - p]
				newSmoothedCoord += pastCoords[i + p]
				newSmoothedCoord = newSmoothedCoord / (2 * smoothingStrength)
			smoothedCenterCoords.append(newSmoothedCoord)

func createWallCoords(coordsArray, angleArray, radius, thickness):
	var newTopWallFarCoords = []
	var newTopWallCloseCoords = []
	var newBottomWallFarCoords = []
	var newBottomWallCloseCoords = []
	for i in range(0, coordsArray.size() - 1):
		var newWallAngle = angleArray[i] - PI/2
		newTopWallFarCoords.append(coordsArray[i] + (Vector2(cos(newWallAngle), sin(newWallAngle)) * (radius + thickness)))
		newTopWallCloseCoords.append(coordsArray[i] + (Vector2(cos(newWallAngle), sin(newWallAngle)) * (radius - thickness)))
		newWallAngle = angleArray[i] + PI/2
		newBottomWallFarCoords.append(coordsArray[i] + (Vector2(cos(newWallAngle), sin(newWallAngle)) * (radius + thickness)))
		newBottomWallCloseCoords.append(coordsArray[i] + (Vector2(cos(newWallAngle), sin(newWallAngle)) * (radius - thickness)))
	print(str(newTopWallCloseCoords.size()))
	wall1Coords = newTopWallFarCoords# + newTopWallCloseCoords.invert()
	for i in range(0, newTopWallCloseCoords.size() - 1):
		wall1Coords.append(newTopWallCloseCoords[newTopWallCloseCoords.size() - 1 - i])
	wall2Coords = newBottomWallFarCoords# + newBottomWallCloseCoords.invert()
	for i in range(0, newBottomWallCloseCoords.size() - 1):
		wall2Coords.append(newBottomWallCloseCoords[newBottomWallCloseCoords.size() - 1 - i])

func _ready(): #generateMapCoords(startCoords, startAngle, length, radius, turnRate, thickness, resolution)
	pass
	#generateMapCoords(Vector2(512, 300), 0, 10000, 150, PI / 40, 5, 1) #for some reason the wall is only drawn if radius - thickness < 12
