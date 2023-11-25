extends CharacterBody3D

class_name Player

var id: int = -1

@export var sprint_enabled = true
@export var crouch_enabled = true

@export var base_speed = 5
@export var sprint_speed = 8
@export var jump_velocity = 4
@export var sensitivity = 0.1
@export var accel = 10
@export var crouch_speed = 3
var speed = base_speed
var sprinting = false
var crouching = false
var camera_fov_extents = [75.0, 85.0] #index 0 is normal, index 1 is sprinting
var base_player_y_scale = 1.0
var crouch_player_y_scale = 0.75


@onready var parts = {
	"head": $head,
	"camera": $head/camera,
	"camera_animation": $head/camera/camera_animation,
	"body": $body,
	"collision": $collision
}
@onready var world = get_parent()

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	print("My id is ", id)
	self.set_multiplayer_authority(id)
	print(Network.get_my_id())
	if id == Network.get_my_id():
		parts.camera.current = true
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _process(delta):
	if id != Network.get_my_id():
		return
	
	rpc("sync_over_network", self.global_position)
	
	if Input.is_action_pressed("left_shift") and !Input.is_action_pressed("ctrl") and sprint_enabled:
		sprinting = true
		speed = sprint_speed
		parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[1], 10*delta)
	elif Input.is_action_pressed("ctrl") and !Input.is_action_pressed("left_shift") and sprint_enabled:
		crouching = true
		speed = crouch_speed
		parts.body.scale.y = lerp(parts.body.scale.y, crouch_player_y_scale, 10*delta) #change this to starting a crouching animation or whatever
		parts.collision.scale.y = lerp(parts.collision.scale.y, crouch_player_y_scale, 10*delta)
	else:
		sprinting = false
		crouching = false
		speed = base_speed
		if sprint_enabled:
			parts.camera.fov = lerp(parts.camera.fov, camera_fov_extents[0], 10*delta)
		if crouch_enabled:
			parts.body.scale.y = lerp(parts.body.scale.y, base_player_y_scale, 10*delta) #see comment on line 48
			parts.collision.scale.y = lerp(parts.collision.scale.y, base_player_y_scale, 10*delta)

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_pressed("space") and is_on_floor():
		velocity.y += jump_velocity

	var input_dir = Input.get_vector("left", "right", "up", "down")
	var direction = input_dir.normalized().rotated(-parts.head.rotation.y)
	direction = Vector3(direction.x, 0, direction.y)
	if is_on_floor(): #don't lerp y movement
		velocity.x = lerp(velocity.x, direction.x * speed, accel * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, accel * delta)
	
	#bob head
	if input_dir and is_on_floor():
		parts.camera_animation.play("head_bob", 0.5)
	else:
		parts.camera_animation.play("reset", 0.5)

	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion:
		if true:#!world.paused:
			parts.head.rotation_degrees.y -= event.relative.x * sensitivity
			parts.head.rotation_degrees.x -= event.relative.y * sensitivity
			parts.head.rotation.x = clamp(parts.head.rotation.x, deg_to_rad(-90), deg_to_rad(90))

func _on_pause():
	pass

func _on_unpause():
	pass

@rpc ("authority")
func sync_over_network(pos: Vector3):
	self.global_position = pos
