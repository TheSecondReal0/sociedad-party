extends Area3D

@export var collision_shape: CollisionShape3D = null
@export var frequency: float = 1

var rng: RandomNumberGenerator = RandomNumberGenerator.new()

var object_resources: Array[DodgeResource] = []

var timer: float = 0
var timer_threshold: float = 1.0 / frequency

func _ready():
	rng.randomize()
	timer_threshold = 1.0 / frequency
	
	var resources: Array = Helpers.load_files_in_dir_with_exts("res://games/dodge/objects", [".tres"])
	for res in resources:
		print(res.name)
		object_resources.append(res)
	pass

func _process(delta):
	timer += delta
	if timer >= timer_threshold:
		timer -= timer_threshold
		spawn_random_object()

#returns a random point in the collision area
func get_random_point_in_area() -> Vector3:
	var shape: BoxShape3D = collision_shape.shape
	var size: Vector3 = shape.get_size()
	
	#get random point
	var point: Vector3 = Vector3(
		rng.randf_range(0, size.x),
		rng.randf_range(0, size.y),
		rng.randf_range(0, size.z)
	)
	
	#offset to center
	point.x -= size.x/2
	point.y -= size.y/2
	point.z -= size.z/2
	
	#offset with current transform
	#point += self.transform
	
	return point

func spawn_random_object() -> void:
	var point: Vector3 = get_random_point_in_area()
	var object: DodgeResource = object_resources[rng.randi()%object_resources.size()]
	
	var spawned_object: DodgeObject = object.scene.instantiate()
	self.add_child(spawned_object)
	spawned_object.transform.origin = point
