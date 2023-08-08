extends Area2D

var speed = 1000

var damage = 10

var actualDamage = 10

var bounces = 5

var bulletRange = 100

var shooter = "Player"

var distanceTraveled = 0.0

var noSelfDamage = false

var selfCollide = true

var velocity = Vector2()

func start(pos, rot):
	position = pos
	rotation = rot
	velocity = Vector2(speed, 0).rotated(rotation)

func _physics_process(delta):
	position += velocity * delta
	distanceTraveled += speed * delta
	if distanceTraveled >= bulletRange:
		queue_free()
		#actualDamage = (damage * ((bulletRange - distanceTraveled) / bulletRange)) + (damage / 2)

func _on_DespawnTimer_timeout():
	queue_free()

func _on_SelfCollideTimer_timeout():
	$CollisionShape2D.disabled = false

func _on_Pellet_body_entered(body):
	if body.name == "Pellet":
		pass
	if body.name == "Bullet":
		queue_free()
	if body.has_method("hit"):
		actualDamage = damage
		body.hit(actualDamage, shooter)
		queue_free()
	else:
		queue_free()
