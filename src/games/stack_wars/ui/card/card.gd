extends Control

var card: StackWars_Card = null

@export var title: Label
@export var texture: TextureRect
@export var description: RichTextLabel
@export var turn_constraint: Label

signal selected

func init_card(_card: StackWars_Card) -> void:
	card = _card
	title.text = card.title
	description.text = card.description
	turn_constraint.text = card.turn_constraint_num as String

func _on_gui_input(event: InputEvent):
	if event.is_action("ui_select"):
		selected.emit()
	if not event is InputEventMouseButton:
		return
	event = event as InputEventMouseButton
	if event.button_mask != MOUSE_BUTTON_LEFT or not event.pressed:
		return
	selected.emit()
