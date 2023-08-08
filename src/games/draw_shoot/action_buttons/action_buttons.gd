extends Control

onready var queue: Control = $queue
onready var available: Control = $available
onready var submit_button = get_node("submit")

var action_queue: Array = []
var action_queue_text: Array = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func new_round():
	action_queue.clear()
	action_queue_text.clear()
	queue.new_round()
	available.new_round()

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func get_actions() -> Array:
	return action_queue

func _on_queue_action_removed(idx: int):
	action_queue.remove(idx)
	action_queue_text.remove(idx)
	submit_button.disabled = true

func _on_available_action_chosen(action: String):
	print(action_queue, " ", action_queue.size())
	if action_queue.size() > 2:
		print("action queue too big")
		return
	action_queue.append(action)
	action_queue_text.append(action)
	queue.add_action(action)
	if action_queue.size() == 3 and Network.get_my_id() in get_parent().alive_players:
		submit_button.disabled = false

func _on_available_player_action_chosen(action: String, player_id: int, player_name: String):
	print(action_queue, " ", action_queue.size())
	if action_queue.size() > 2:
		return
	var action_text: String = action + " " + player_name
	action_queue.append(action + " " + str(player_id))
	action_queue_text.append(action_text)
	queue.add_action(action_text)
	if action_queue.size() == 3 and Network.get_my_id() in get_parent().alive_players:
		submit_button.disabled = false
