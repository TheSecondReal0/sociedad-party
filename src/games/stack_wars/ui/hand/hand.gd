extends ScrollContainer

@export var card_scene: PackedScene
@export var card_container: Container

signal card_selected(card: StackWars_Card)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func show_cards(cards: Array[StackWars_Card]) -> void:
	for child in card_container.get_children():
		child.queue_free()
	for card in cards:
		show_card(card)

func show_card(card: StackWars_Card) -> void:
	var node: Control = card_scene.instantiate()
	card_container.add_child(node)
	node.init_card(card)
