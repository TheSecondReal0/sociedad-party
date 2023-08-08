extends HBoxContainer

var queue: Array = []
var buttons: Array = []

signal action_removed(idx)

func new_round():
	for button in buttons:
		button.queue_free()
	queue = []
	buttons = []

func add_action(action: String):
	print("adding action: ", action)
	create_button(action)
	print(queue, buttons)

func button_pressed(button: Button):
	print(range(0, buttons.size()))
	for i in range(0, buttons.size()):
		if button == buttons[i]:
			queue.remove(i)
			buttons.remove(i)
			button.queue_free()
			emit_signal("action_removed", i)
			break
	print(queue, buttons)

func create_button(action: String):
	var button: Button = Button.new()
	button.text = action
	queue.append(action)
	buttons.append(button)
	button.connect("pressed", self, "button_pressed", [button])
	add_child(button)
