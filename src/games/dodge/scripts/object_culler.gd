extends Area3D

@export var collision_shape: CollisionShape3D = null

func _ready():
	self.connect("body_entered", on_body_entered)
	pass

func _process(delta):
	pass

func on_body_entered(body: Node3D):
	if body is DodgeObject:
		body.queue_free()
	pass
