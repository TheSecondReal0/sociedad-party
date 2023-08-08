extends Control

onready var timer = $Timer

# time in seconds between game setup and game start
var starting_time: int = 3
var current_time: int = starting_time

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.connect("timeout", self, "on_timer_timeout")

func start_game():
	if get_tree().is_network_server():
		GameManager.start_game()
	UIManager.close_ui("res://assets/ui/timer_ui/timer_ui.tscn")
	close()

# called by ui_controller when opened by the UI system
func open():
	show()
	reset_timer()
	current_time = starting_time

# called by ui_controller when closed by UI system
func close():
	stop_timer()
	hide()

func on_timer_timeout():
	current_time -= 1
	if current_time < 1:
		start_game()
	$Label.text = str(current_time)

func reset_timer():
	$Label.text = str(starting_time)
	stop_timer()
	start_timer()

func start_timer():
	timer.start(1.0)

func stop_timer():
	timer.stop()
