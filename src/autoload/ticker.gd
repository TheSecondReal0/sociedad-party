extends Node

puppet var tick_rate: float = 0.1
var time_since_tick: float = 0.0

signal tick

func _ready():
	# set network master to server
	set_network_master(1)
	pause_mode = PAUSE_MODE_STOP

func _process(delta):
	time_since_tick += delta
	if time_since_tick >= tick_rate:
		tick()
		time_since_tick = 0.0

func tick():
	emit_signal("tick")

func update_tick_rate(rate: float):
	tick_rate = rate
	if not get_tree().is_network_server():
		return
	rset("tick_rate", tick_rate)
