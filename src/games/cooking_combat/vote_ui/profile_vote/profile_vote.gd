extends Control

onready var profile: Node = $flavor_profile
onready var vote: Button = $vote
onready var victory_rect: ColorRect = $vote/ColorRect

export var sprite_scale: int = 50

signal voted_for

func _ready():
	profile.set_sprite_scale(sprite_scale)
# warning-ignore:return_value_discarded
	vote.connect("pressed", self, "vote_pressed")

func profile_won():
	victory_rect.show()

func new_flavor_amounts(flavor_amounts):
	profile.new_flavor_amounts(flavor_amounts)

func vote_pressed():
	emit_signal("voted_for")
