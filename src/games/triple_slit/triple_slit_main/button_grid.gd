extends GridContainer

var button_scene: PackedScene = load("res://games/triple_slit/button/button.tscn")

signal button_pressed(button_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		child.queue_free()
	create_buttons(30)

func create_buttons(amount: int):
	for child in get_children():
		child.name = child.name + "deleting"
		child.queue_free()
	for i in range(1, amount + 1):
		create_button(str(i))

func create_button(label_text: String):
	var button: Button = button_scene.instance()
	button.name = label_text
	add_child(button)
	button.set_label_text(label_text)
# warning-ignore:return_value_discarded
	button.connect("pressed", self, "button_pressed", [label_text])

func button_pressed(button_name: String):
	if can_press_buttons():
		emit_signal("button_pressed", button_name)

func can_press_buttons() -> bool:
	return get_parent().both_ready()
