extends Control

var ui_data: Dictionary = {}

func open():
	if ui_data.has("dashes_left"):
		var new_text: String = "Dashes: " + str(ui_data["dashes_left"])
		$dashes.text = new_text


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
