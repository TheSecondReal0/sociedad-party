extends Button

var has_mouse: bool = false

func _process(_delta: float):
	if has_mouse and text == "" and Input.is_action_pressed("left_click"):
		emit_signal("pressed")

func update_button(remote_pressed: bool):
	if remote_pressed:
		text = "PRESSED"
		set("custom_colors/font_color", Color(0, 1, 0))
	else:
		text = "UNPRESSED"

func set_label_text(new_text: String):
	$Label.text = new_text

func _on_button_mouse_entered():
	has_mouse = true

func _on_button_mouse_exited():
	has_mouse = false

func _on_button_focus_entered():
	release_focus()
