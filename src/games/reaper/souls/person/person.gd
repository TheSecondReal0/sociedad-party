extends KinematicBody2D

onready var collision_shape = $CollisionShape2D
onready var polygon = $Polygon2D
onready var poof_timer = $poof_timer

var dir: Vector2 = Vector2()

var speed = 40

var harvestable: bool = false
var harvested: bool = false

var time_safe: float = 5
var time_harvestable: float = 2.5

var time_until_harvestable: float = time_safe
var time_until_poof: float = time_harvestable

func _process(delta):
	if harvested:
		return
	if harvestable:
		time_until_poof -= delta
		if time_until_poof <= 0:
			poof(true)
	else:
		time_until_harvestable -= delta
		if time_until_harvestable <= 0:
			become_harvestable()
	update_color()
	
# warning-ignore:return_value_discarded
	move_and_collide(dir * speed * delta)

func update_color() -> void:
	var progress: float
	var new_color: Color
	if harvestable:
		progress = time_until_poof / time_harvestable
		new_color = Color(1, progress, progress, 1)
	else:
		progress = (time_until_harvestable / time_safe) / 2
		progress += .5
#		if progress > 0.8:
#			progress = 0.8
		new_color = Color(1, 1, 1, 1 - progress)
#	print(progress)
#	print(new_color)
	polygon.color = new_color

func harvest() -> int:
#	print("harvested")
	poof()
#	print(time_until_harvestable / time_safe)
	if harvestable:# or time_until_harvestable / time_safe < .1:
		return 1
	return 0

func become_harvestable():
	harvestable = true

func poof(explode: bool = false):
	harvested = true
	$Polygon2D.hide()
	collision_shape.set_deferred("disabled", true)
	poof_timer.start()
	if explode:
		$CPUParticles2D.restart()

func get_new_dir() -> Vector2:
	return Vector2(rand_range(-1, 1), rand_range(-1, 1)).normalized()

func _on_poof_timer_timeout():
	queue_free()
