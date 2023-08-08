extends Control

var firework_scene: PackedScene = load("res://games/bombertron/assets/ui/win_screen/firework/firework.tscn")

var fireworks: Array = []

var time_until_firework: float = 0.0
var time_between_fireworks: float = 0.75

onready var label: Label = $ColorRect/Label

func _process(delta: float) -> void:
	if not visible:
		return
	time_until_firework -= delta
	if time_until_firework < 0:
		spawn_firework()
		time_until_firework = time_between_fireworks
		if fireworks.size() > 5:
			fireworks.pop_front().queue_free()

func spawn_firework() -> void:
	var firework: CPUParticles2D = firework_scene.instance()
	var firework_color: Color = Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
	var firework_pos: Vector2 = Vector2(rand_range(100, 924), rand_range(100, 500))
	firework.color = firework_color
	firework.position = firework_pos
	fireworks.append(firework)
	add_child(firework)
	firework.emitting = true

func show_winner(winner_id: int) -> void:
	if visible:
		return
	if winner_id == 0:
		label.text = "Nobody wins :("
	else:
		label.text = Network.get_player_name(winner_id) + " wins!"
	show()
