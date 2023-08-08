extends Area2D

signal clicked(event)

func _input_event(_viewport, event, _shape_index):
	if not event is InputEventMouseButton:
		return
	# doesn't actually change anything, just makes the text prediction stuff work
	event = event as InputEventMouseButton
#	match event.button_index:
#		BUTTON_LEFT:
#			print("left")
#			pass
#		BUTTON_RIGHT:
#			print("right")
#			pass
	emit_signal("clicked", event)
