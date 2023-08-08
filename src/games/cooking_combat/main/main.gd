extends Control

onready var ingredient_hbox: HBoxContainer = $HBoxContainer
onready var flavor_preview: Control = $flavor_profile
onready var submit: Button = $submit
onready var reset: Button = $reset
onready var vote_ui: Control = $vote_ui

var flavor_amounts: Dictionary = {}#{"Red Zest": 0, "Green Caustic": 0, "Blue Crackle": 0}
var received_profiles: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for button in ingredient_hbox.get_children():
		button.connect("pressed", self, "button_pressed", [button.text])
# warning-ignore:return_value_discarded
	submit.connect("pressed", self, "submit_pressed")
	reset.connect("pressed", self, "reset_pressed")

func show_all_profiles():
	print("showing all profiles")
	for node in [ingredient_hbox, flavor_preview, submit]:
		node.hide()
	vote_ui.create_profiles(received_profiles)
	vote_ui.show()

func submit_pressed():
	print("profile submitted")
	send_profile()

func reset_pressed():
	print("reset pressed")
	flavor_amounts.clear()
	update_profile()

func send_profile():
	rpc("receive_profile", flavor_amounts, Network.get_my_id())

remotesync func receive_profile(received_amounts: Dictionary, network_id: int):
	print("received profile from ", network_id, ": ", received_amounts)
	received_profiles[network_id] = received_amounts
	if are_all_profiles_submitted():
		show_all_profiles()

func are_all_profiles_submitted() -> bool:
	for player in Network.get_peers():
		if not player in received_profiles:
			print(player, " has not submitted profile")
			return false
	print("all profiles submitted")
	return true

func update_profile():
	flavor_preview.new_flavor_amounts(flavor_amounts)

func button_pressed(flavor: String):
	if not flavor in flavor_amounts:
		flavor_amounts[flavor] = 0.0
	flavor_amounts[flavor] += 1.0
	update_profile()
