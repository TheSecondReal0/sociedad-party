extends Node2D

remote var hooked = false

var anchor = load("res://games/2d_mad_max_original/assets/weapons/harpoon/anchor.tscn")

var newPoint

var currentAnchor

var currentLine

var anchorType = "point"

var anchorCoords = Vector2(0, 0)

var ropeLength

var currentRot = 0

func fire(direction, angle):
	rotateEverything(angle)
	print("firing harpoon")
	if not hooked:
	#	node_a = "../.."
		if get_node(direction).is_colliding():
			var collider = get_node(direction).get_collider()
			print(collider)
			anchorCoords = get_node(direction).get_collision_point()
			print("collision position: " + str(anchorCoords))
			if collider is RigidBody2D:
				print("found RigidBody2D")
				anchorType = "player"
				currentAnchor = collider
				ropeLength = currentAnchor.global_position.distance_to(get_parent().get_parent().global_position) #/ 2
			#	set_node_b("../../../" + collider.name)
				hooked = true
				rset("hooked", true)
				$rope.createRope(ropeLength, collider, dirToAngle(direction) - 90)
			elif collider is StaticBody2D:
				if collider.is_in_group("walls"):
					ropeLength = anchorCoords.distance_to(get_parent().get_parent().global_position) #/ 2
			#		print(str(length))
					createAndAnchorToNew(anchorCoords, direction)
		else:
			pass #if given raycast is not colliding
	else:
		print("releasing anchor")
		#set_node_b("")
		var newPoint
		$rope.deleteRope()
		hooked = false
		rset("hooked", false)
#		if get_children().has(currentLine):
#			currentLine.queue_free()
	rotateEverything(-angle)

func remoteFire(direction, angle, newHooked):
	hooked = newHooked
	rotateEverything(angle)
	print("firing harpoon")
	if not hooked:
		#node_a = "../.."
		if get_node(direction).is_colliding():
			var collider = get_node(direction).get_collider()
			print("harpoon collided with " + str(collider))
			anchorCoords = get_node(direction).get_collision_point()
			print("collision position: " + str(anchorCoords))
			if collider is RigidBody2D:
				print("found RigidBody2D")
				anchorType = "player"
				currentAnchor = collider
				ropeLength = currentAnchor.global_position.distance_to(get_parent().get_parent().global_position) #/ 2
				#set_node_b("../../../" + collider.name)
				hooked = true
				$rope.createRope(ropeLength, collider, dirToAngle(direction) - 90)
			elif collider is StaticBody2D:
				if collider.is_in_group("walls"):
					ropeLength = anchorCoords.distance_to(get_parent().get_parent().global_position) #/ 2
					createAndAnchorToNew(anchorCoords, direction)
		else:
			pass #if given raycast is not colliding
	else:
		print("releasing anchor")
		#set_node_b("")
		var newPoint
		$rope.deleteRope()
		hooked = false
#		if get_children().has(currentLine):
#			currentLine.queue_free()
	rotateEverything(-angle)

func createAndAnchorToNew(anchorPos, direction):
	print("creating anchor point at " + str(anchorPos))
	
	newPoint = anchor.instance()
	if direction == "left":
		anchorPos = to_global(Vector2(cos(PI/2), sin(PI/2)) * ropeLength)
	#	newPoint.global_position = anchorPos
	elif direction == "forward":
		anchorPos = to_global(Vector2(cos(0), sin(0)) * ropeLength)
	#	newPoint.global_position = anchorPos
	else:
		anchorPos = to_global(Vector2(cos(90), sin(90)) * ropeLength)
	#	newPoint.global_position = anchorPos
	get_parent().get_parent().get_parent().add_child(newPoint)
	#set_node_b("../../../" + newPoint.name)
	currentAnchor = newPoint
	print("anchor pos: " + str(currentAnchor.global_position))
	anchorType = "point"
	hooked = true
	$rope.createRope(ropeLength, currentAnchor, dirToAngle(direction) - 90)
	#createNewLine()

func createNewLine():
	var newLine = Line2D.new()
	newLine.add_point(Vector2(0, 0))
	newLine.add_point(Vector2(0, 0))
	newLine.width = 3
	add_child(newLine)
	currentLine = newLine

func rotateEverything(angle):
	rotation_degrees += angle + currentRot
	for i in get_children():
		if i is RayCast2D:
			rotation_degrees -= angle + currentRot
	currentRot = angle + currentRot

func dirToAngle(direction):
	if direction == "left":
		return -90
	elif direction == "forward":
		return 0
	else:
		return 90

#func _process(delta):
#	if hooked:
#		if anchorType == "point":
#			currentLine.points[1] = to_local(anchorCoords)
#			#print(currentAnchor.global_position)
#		elif anchorType == "player":
#			currentLine.points[1] = to_local(get_node(node_b).global_position)
#	else:
#		pass
#		#$Line2D.points[1] = Vector2(0, 0)

func _on_Node_ready():
	for i in get_children():
		if i is RayCast2D:
			i.add_exception(get_parent().get_parent())
	hooked = false
	#$rope/ropeBeg.node_a = "../../.."
