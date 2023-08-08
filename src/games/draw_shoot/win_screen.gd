extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func victory(player_id: int):
	$Label.text = Network.names[player_id] + " won!"
	show()

func tie():
	$Label.text = "Tie!"
	show()

func show_screen():
	pass
