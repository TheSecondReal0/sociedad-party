extends Control

var card: StackWars_Card = null

@export var title: Label
@export var texture: TextureRect
@export var description: RichTextLabel
@export var turn_constraint: Label

func init_card(_card: StackWars_Card) -> void:
	card = _card
	title.text = card.title
	description.text = card.description
	turn_constraint.text = card.turn_constraint
