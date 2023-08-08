extends Node2D

var link = load("res://games/2d_mad_max_original/assets/weapons/harpoon/link.tscn")

var firstLink = true

var currentLink #which node to add new links as child to

func createRope(length, anchor, rot):
	print("creating rope")
	firstLink = true
	currentLink = getPlayerNode()
	var links = round(length / 10)
	for i in links:
		createLink(rot)
	createLastLink(anchor)

func createLink(rot):
	var newLink = link.instance()
	if firstLink:
		newLink.rotation_degrees += rot
	var joint = currentLink.get_node("PinJoint2D")
	joint.add_child(newLink)
	joint.node_a = currentLink.get_path()
	joint.node_b = newLink.get_path()
	currentLink = newLink
	firstLink = false

func createLastLink(anchor):
	var joint = currentLink.get_node("PinJoint2D")
	joint.node_a = currentLink.get_path()
	joint.node_b = anchor.get_path()

func deleteRope():
	print("deleting rope")
	getPlayerNode().get_node("PinJoint2D").node_a = ""
	if get_node("PinJoint2D/link"):
		getPlayerNode().get_node("PinJoint2D/link").free()
	print("rope deleted")

func getPlayerNode():
	return get_parent().get_parent().get_parent()

func _ready():
	pass
	#createRope(50, null)
