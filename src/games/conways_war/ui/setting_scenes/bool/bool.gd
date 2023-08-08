extends HBoxContainer



onready var label: Label = $name
onready var toggle: Button = $toggle

signal changed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_text(text: String) -> void:
	label.text = text

func get_text() -> String:
	return label.text

func set_tooltip(text: String) -> void:
	label.hint_tooltip = text

func set_value(pressed: bool) -> void:
	toggle.pressed = pressed

func get_value() -> bool:
	return get_state()

func get_state() -> bool:
	return toggle.pressed


func _on_toggle_pressed():
	emit_signal("changed")
