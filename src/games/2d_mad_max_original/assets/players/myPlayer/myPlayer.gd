extends RigidBody2D

var velocity = Vector2()
const acceleration = .5
const braking = .3
const resistances = 2 # ground and air friction, constant for simplicity.
# deaceleration force of wheels when not in the same 
const wheelDriftResistance = 5 #direction as to velocity.
const maxSpeed = 50
const rotationSpeed = 5
# minimal percentage of angle difference. If lower - velocity direction
const minWDrResStr = 0.05 # changed to car direction. 1 = PI/2, should be less then rotationSpeed
const spriteAngle = -PI/2 # default sprite image and thus acceleration vector angle
const spriteSize = Vector2(20,40)
slave var slaveLinear = Vector2()
slave var slaveAngular = 0
slave var slavePos = Vector2()
slave var slaveRot = 0
var syncPosRot = false
var delete = false
var scalar = 980

func _physics_process(_delta):
	if delete:
		queue_free()
	if is_network_master():
		if Input.is_action_pressed('left') or Input.is_action_pressed('right'):
			if Input.is_action_pressed('left'):
				angular_velocity -= rotationSpeed * _delta
			if Input.is_action_pressed('right'):
				angular_velocity += rotationSpeed * _delta
		if Input.is_action_pressed("up"):
		#	if (linear_velocity + Vector2(cos(rotation), sin(rotation)) * acceleration * _delta).length() < maxSpeed:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * acceleration * _delta * scalar)
		if Input.is_action_pressed("down"):
			if linear_velocity.length() > 0:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * -braking * _delta * scalar)
			else:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * -acceleration * _delta * scalar)
		if Input.is_action_pressed("space"):
			linear_damp = 3
			angular_damp = 1.25
		else:
			linear_damp = 1
			angular_damp = .75
		rset_unreliable("slaveLinear", linear_velocity)
		rset_unreliable("slaveAngular", angular_velocity)
		rset_unreliable("slavePos", position)
		rset_unreliable("slaveRot", rotation)
	else:
		linear_velocity = slaveLinear
		angular_velocity = slaveAngular
		if syncPosRot:
			syncPosRot()
			syncPosRot = false
	$name.set_rotation(-global_rotation)

slave func syncPosRot():
	mode = MODE_STATIC
	position = slavePos
	rotation = slaveRot
	mode = MODE_RIGID
	angular_velocity = slaveAngular
	linear_velocity = slaveLinear

func fireHarpoon():
	pass

func getExploded(bombPos, force):
	var angleToBomb = position.angle_to(bombPos)
	var vectorToBomb = Vector2(cos(angleToBomb - PI), sin(angleToBomb - PI))
	if global_position.x < bombPos.x:
		vectorToBomb = Vector2(cos(angleToBomb), sin(angleToBomb))
	apply_central_impulse(-vectorToBomb * force * scalar) #Vector2(cos(angleToBomb - PI - rotation), sin(angleToBomb - PI - rotation)) * force)

func _on_syncPosRot_timeout():
	syncPosRot = true

func _ready():
	if is_network_master():
		$camera.current = true
	#$name.text = Network.names[name]
