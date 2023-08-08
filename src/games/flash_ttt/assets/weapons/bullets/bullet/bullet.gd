extends KinematicBody2D

var speed = 1000

var damage = 10

var actualDamage = 10

var bounces = 5

var penetration = 0

var bulletRange = 100.0

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
	var collision = move_and_collide(velocity * delta)
	distanceTraveled += speed * delta
	if distanceTraveled >= bulletRange:
		queue_free()
	actualDamage = damage
	#actualDamage = (damage * ((((bulletRange - distanceTraveled) / bulletRange)) + (damage / 2)))
	#actualDamage -= (damage/bulletRange) * delta
	if collision:
		var collider = collision.get_collider()
		if collider.has_method("hit"):
			#if collider.name != shooter:
			collider.hit(actualDamage, shooter)
			if penetration < 1:
				queue_free()
			else:
				queue_free()
		elif bounces > 0:
				velocity = velocity.bounce(collision.normal)
				bounces -= 1
		else:
			queue_free()

func _on_DespawnTimer_timeout():
	queue_free()

func _on_SelfCollideTimer_timeout():
	$CollisionShape2D.disabled = false

# warning-ignore:unused_argument
func _on_BulletHitReg_body_entered(collider):
	pass
	#if collider.has_method("hit"):
	#	if collider.name != shooter:
	#		collider.hit(actualDamage, shooter)
	#		if penetration < 1:
	#			queue_free()
