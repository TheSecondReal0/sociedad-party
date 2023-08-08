extends RigidBody2D

var velocity = Vector2()
const acceleration = .5
const braking = .3
const turnSpeed: float = 25.0
const driftTurnSpeed: float = 35.0
const resistances = 2 # ground and air friction, constant for simplicity.
# deaceleration force of wheels when not in the same 
const wheelDriftResistance = 5 #direction as to velocity.
const maxSpeed = 1500
const maxDriftSpeed = 100
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
	#print(linear_velocity.length())
	if is_network_master():
		var dir_vec: Vector2 = Vector2(cos(rotation), sin(rotation))
		var forward_vel: float = linear_velocity.dot(dir_vec)
		#print(forward_vel)
		if Input.is_action_pressed("space"):
			linear_damp = 1.5
			angular_damp = 2.5
			var capped_vel: Vector2 = linear_velocity.linear_interpolate(Vector2.ZERO, _delta / 10) #linear_velocity.normalized() * maxDriftSpeed
			#if linear_velocity.length() > capped_vel.length():
			#linear_velocity = capped_vel
		else:
			linear_damp = 1.5
			angular_damp = 7.5
			var perp_dir_vec: Vector2 = dir_vec.rotated(-PI/2)
			var perp_vel: float = linear_velocity.dot(perp_dir_vec)
			var perp_vel_vec: Vector2 = perp_dir_vec * perp_vel
			#print(perp_vel)
			#print("canceling perp vel: ", perp_vel_vec)
			#print("start: ", linear_velocity)
			#linear_velocity -= perp_vel_vec * _delta * 3
			#print("after: ", linear_velocity)
			var damp_perp_vel_percent: float = 1.0 - ((perp_vel - 75) / 25)
			
			damp_perp_vel_percent = clamp(damp_perp_vel_percent, 0.4, 1.0)
			#var perp_vel_threshold: int = 150
			#if abs(perp_vel) > perp_vel_threshold:
			#	damp_perp_vel_percent = (abs(perp_vel) - perp_vel_threshold) / abs(perp_vel)
			apply_impulse(Vector2(0, 0), -perp_vel_vec * _delta * 5 * damp_perp_vel_percent)
		if Input.is_action_pressed('left') or Input.is_action_pressed('right'):
			var currTurnSpeed = turnSpeed
			# also handles swapping turn directions when going backwards
			var steeringPercent: float = min(1.0, forward_vel / 200.0)
			if Input.is_action_pressed("space"):
				currTurnSpeed = driftTurnSpeed
				steeringPercent = min(1.0, linear_velocity.length() / 200.0)#1.0
			#var directionSign: int = 1
			if Input.is_action_pressed("down"):
				pass
				#directionSign = -1
			var new_angular: float = 0.0
			if Input.is_action_pressed('left'):
				new_angular += -rotationSpeed * _delta * currTurnSpeed# * directionSign
				#angular_velocity = min(angular_velocity, -rotationSpeed * _delta * currTurnSpeed * directionSign)
			if Input.is_action_pressed('right'):
				new_angular += rotationSpeed * _delta * currTurnSpeed# * directionSign
				#angular_velocity = max(angular_velocity, rotationSpeed * _delta * currTurnSpeed * directionSign)
			new_angular *= steeringPercent
			if new_angular > 0:
				angular_velocity = max(angular_velocity, new_angular)
			else:
				angular_velocity = min(angular_velocity, new_angular)
		if Input.is_action_pressed("up"):
			var currMaxSpeed: int = maxSpeed
			if Input.is_action_pressed("space"):
				pass
				#currMaxSpeed = maxDriftSpeed
			if (linear_velocity + Vector2(cos(rotation), sin(rotation)) * acceleration * _delta).dot(dir_vec) < currMaxSpeed:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * acceleration * _delta * scalar)
		if Input.is_action_pressed("down"):
			if linear_velocity.length() > 0:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * -braking * _delta * scalar)
			else:
				apply_impulse(Vector2(0, 0), Vector2(cos(rotation), sin(rotation)) * -acceleration * _delta * scalar)

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
