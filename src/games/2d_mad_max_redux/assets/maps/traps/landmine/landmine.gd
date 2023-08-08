extends Area2D

var force = 1

var explosionRange = 50

var exploded = false

func _ready():
	pass

func explode():
	exploded = true
	$CollisionShape2D.disabled = true
	$Polygon2D.hide()
	$CPUParticles2D.emitting = true
	$particleTimer.start()

func _on_landmine_body_entered(body):
	if body.has_method("getExploded"):
		if not exploded:
			body.getExploded(global_position, force)
			explode()

func _on_particleTimer_timeout():
	queue_free()
