extends HBoxContainer



onready var label: Label = $name
onready var value: Label = $value
onready var slider: HSlider = $slider

signal changed

# Called when the node enters the scene tree for the first time.
func _ready():
	update_value_text()

func set_text(text: String) -> void:
	label.text = text

func set_tooltip(text: String) -> void:
	label.hint_tooltip = text
	#print(label.hint_tooltip)

func set_value(value: int) -> void:
	slider.value = value

func get_value() -> int:
	return int(slider.value)

func update_value_text() -> void:
	value.text = str(slider.value)

func set_range(minimum: int, maximum: int) -> void:
	slider.min_value = minimum
	slider.max_value = maximum

func get_state() -> int:
	return int(slider.value)


func _on_slider_value_changed(value):
	update_value_text()
	emit_signal("changed")
