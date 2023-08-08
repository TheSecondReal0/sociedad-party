extends KinematicBody2D

var speed = 500

remote var health = 100

var maxHealth = 100

var spriteRadius = 25

var noSelfDamage = true

var playerName = "Name"

#var nameLabel = preload("res://scenes/NameText.tscn").instance()

remote var slavePos = Vector2()

remote var slaveRot = 0

var alive = true

var team = ""

var credits = 0

# warning-ignore:unused_signal
signal myPlayerLoaded

onready var deathCam = get_node("../../DeathCam")

func reportPosRot():
	rset_unreliable("slavePos", position)
	rset_unreliable("slaveRot", rotation)

func getPosRot():
	position = slavePos
	rotation = slaveRot

puppet func updatePosRot(pos, rot):
	if not is_network_master():
		position = pos
		rotation = rot

func pointTowardsMouse():
	look_at(get_global_mouse_position())

var velocity: Vector2 = Vector2()

func hit(damage, shooter) -> void:
	if get_tree().is_network_server():
		if noSelfDamage:
			if shooter != name:
				rpc("updateHealth", -damage)
				updateHealth(-damage)
		else:
			rpc("updateHealth", -damage)
			updateHealth(-damage)

remote func updateHealth(healthChange):
	if alive:
		health += healthChange
		#print("New health: " + str(health))
		if is_network_master() and get_node("PlayerUI"):
			$PlayerUI.updateHealth(health)
		if health <= 0:
			killedBy()

func killedBy():
	if alive:
		alive = false
		if is_network_master():
			$Lighting/RadiusLight.hide()
			$Lighting/RevealEverything.show()
			$Camera.current = false
			deathCam.current = true
		$Lighting.flashToggle(false)
		if is_network_master():
			#if get_parent().has_child("PlayerUI"):
			$PlayerUI.queue_free()
		if team == "traitor":
			$Sprite.modulate = Color(1, 0, 0)
		$Sprite.z_index = 0
	$Sprite/DeathX.modulate = Color(0, 0, 0)
	$Sprite/DeathX.show()

func handleMovementInput():
	pointTowardsMouse()
	velocity = Vector2()
	if Input.is_action_pressed('right'):
		velocity.x += 1
	if Input.is_action_pressed('left'):
		velocity.x -= 1
	if Input.is_action_pressed('down'):
		velocity.y += 1
	if Input.is_action_pressed('up'):
		velocity.y -= 1
	velocity = velocity.normalized() * speed

func handleInput():
	handleMovementInput()

# warning-ignore:unused_argument
func createNameLabel(labelName):
	pass

func _ready():
	if is_network_master():
		#turnOnLOS()
		$Camera.current = true
	createNameLabel(playerName)

func _physics_process(_delta):
	if is_network_master():
		if alive:
			handleInput()
			velocity = move_and_slide(velocity)
			reportPosRot()
			#updateLOSPos()
	else:
		#pass
		getPosRot()
#	nameLabel.rect_position = position - Vector2(200, 80)

func _on_PlayerUI_ready():
	pass
	#if not is_network_master():
	#	$PlayerUI.queue_free()

func _on_Last_ready():
	health = maxHealth
	updateHealth(0)
	if not is_network_master():
		$PlayerUI.queue_free()
	else:
		z_index = 1
		$Lighting/onlyLOS.show()
		$Lighting/LineOfSight.show()
#	if gameManager.teamsInfo.traitors.has(Network.myID):
#		if team == "traitor":
#			credits = 2
#			$Sprite.modulate = Color(1, 0, 0)
#	if team == "detective":
#		if get_parent().get_parent().getTeam(str(Network.myID)) == "detective":
#			credits = 2
#		$Sprite.modulate = Color(0, 0, 1)
