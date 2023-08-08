extends Node

var player_actions: Dictionary = {}
var round_player_actions: Dictionary = {}
var current_player_actions: Dictionary = {}

var player_health: Dictionary = {}

var drawn: Array = []
var aiming: Array = []
var dodging: Array = []

var shooting: Dictionary = {}
var staring: Dictionary = {}
var was_staring: Dictionary = {}
var rushed: Dictionary = {}
var rushing: Dictionary = {}
var rushing_2: Dictionary = {}

var current_action: int = 0

# warning-ignore:unused_signal
signal player_damaged(player_id)
signal new_player_damage(player_damage)

func _ready():
	for id in Network.get_peers():
		player_health[id] = 3

func new_actions(new_actions):
	player_actions = new_actions.duplicate()
	update_round_player_actions()
	for i in [0, 1, 2]:
		current_action = i
		setup_for_next_actions()
		var player_damage: Dictionary = execute_actions()
		print(player_damage)
		emit_signal("new_player_damage", player_damage)
		for player in player_damage:
			if player_damage[player] != 0:
				print("ending round early, ", player, " was damaged")
				return

func execute_actions() -> Dictionary:
	var player_damage: Dictionary = {}
	for player in player_actions:
		player_damage[player] = 0
	print("players getting stared at: ", was_staring.values())
	for player in was_staring.values():
		if player in dodging:
			dodging.erase(player)
		if player in rushing:
			rushing.erase(player)
		if player in rushing_2:
			rushing_2.erase(player)
	for player in shooting:
		var target: int = shooting[player]
		if target in dodging:
			continue
		if target in rushing:
			rushing.erase(player)
		if target in rushed:
			rushed.erase(player)
		# comment out if can't cancel rush on second actoin
		if target in rushing_2:
			rushing_2.erase(player)
		
		var damage: int = 0
		if player in shooting and target in shooting and shooting[target] == player:
			print("both ", player, " and ", target, " shooting")
			if true:
			#if shooting[target] == player:
				print("aiming at each other")
				if player in aiming and target in aiming:
					print("both aiming")
					damage = 0
				elif player in aiming and not target in aiming:
					print(player, " aiming but not ", target)
					damage = 1
				elif not player in aiming and not target in aiming:
					print("neither aiming")
					damage = 0
		elif player in aiming:
			print(player, " is aiming so 2 dmg")
			damage = 2
		else:
			print(player, "is not aiming so 1 dmg")
			damage = 1
		player_damage[target] += damage
	for player in rushing_2:
		if player in shooting.values():
			print("rushing player ", player, " was shot, cancelling rush")
			continue
		if player in was_staring.values():
			print("rushing player ", player, " was stared at, cancelling rush")
			continue
		var target: int = rushing_2[player]
		var damage: int = 1
		player_damage[target] += damage
	return player_damage

func setup_for_next_actions():
	was_staring.clear()
	was_staring = staring.duplicate()
	for player in rushing:
		rushed[player] = rushing[player]
	for list in [dodging, shooting, staring, rushing, rushing_2]:
		list.clear()
	setup_lists(current_action)

func setup_lists(round_num: int = current_action):
	current_player_actions = round_player_actions[round_num].duplicate()
	print(current_player_actions)
	for player in current_player_actions:
		var action: String = current_player_actions[player]
		print(action)
		var found_in_match: bool = false
		if action == "Draw":
			#print("action is draw")
			if not player in drawn:
				drawn.append(player)
			found_in_match = true
		elif action == "Aim":
			#print("action is aim")
			if not player in aiming:
				aiming.append(player)
			found_in_match = true
		elif action == "Dodge":
			#print("action is dodge")
			if not player in dodging:
				dodging.append(player)
			found_in_match = true
		#print(found_in_match)
		if found_in_match:
			continue
		var target_id: int = int(action.split(" ")[1])
		if "Shoot" in action:
			if player in drawn:
				shooting[player] = target_id
		if "Stare" in action:
			staring[player] = target_id
		if "Rush" in action:
			if player in rushing.keys():
				if rushing[player] == target_id:
# warning-ignore:return_value_discarded
					rushing.erase(player)
					rushing_2[player] = target_id
				else:
					rushing[player] = target_id
			elif player in rushed.keys():
				if rushed[player] == target_id:
					rushed.erase(player)
					rushing_2[player] = target_id
				else:
					rushed.erase(player)
			else:
				rushing[player] = target_id

func update_round_player_actions():
	round_player_actions.clear()
	for i in [0, 1, 2]:
		round_player_actions[i] = {}
		for player in player_actions:
			round_player_actions[i][player] = player_actions[player][i]
	print(round_player_actions)

func new_round():
	for list in [aiming, dodging, shooting, staring, was_staring, rushing, rushing_2]:
		list.clear()
