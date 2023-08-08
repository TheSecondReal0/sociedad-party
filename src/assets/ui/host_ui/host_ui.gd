extends Control

onready var switch_button: Button = $Button
onready var game_drop: OptionButton = $OptionButton

# Called when the node enters the scene tree for the first time.
func _ready():
# warning-ignore:return_value_discarded
	switch_button.connect("pressed", self, "switch_game")
	gen_game_buttons()

func switch_game():
	var next_game: String = game_drop.get_item_text(game_drop.selected)
#	print("UI switching game to ", next_game)
	GameManager.switch_game(next_game)

func gen_game_buttons():
	var game_resources = GameManager.get_game_resources()
	for game in game_resources.keys():
		game_drop.add_item(game)

