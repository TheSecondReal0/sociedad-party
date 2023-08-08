extends TextureProgress

export var timer_length: float = 30.0

var timer_started: bool = false
var timer_progress: float = 0.0

signal timer_complete

func _process(delta: float):
	if not timer_started:
		return
	timer_progress += delta
	update_display()
	if timer_progress > timer_length:
		emit_signal("timer_complete")
		stop_timer()

func update_display():
	value = int(timer_progress * 1000)

func start_timer():
	timer_started = true

func stop_timer():
	timer_started = false

func reset_timer():
	timer_progress = 0.0
	update_display()
