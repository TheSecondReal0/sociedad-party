extends ScrollContainer

onready var container: Control = $HBoxContainer

var panel_scene: PackedScene = load("res://games/draw_shoot/player_panels/player_panel/player_panel.tscn")

var player_panels: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	for id in Network.get_peers():
		create_panel(id)

func new_player_actions(player_actions: Dictionary):
	for player_id in player_actions.keys():
		player_panels[player_id].new_actions(player_actions[player_id])

func create_panel(player_id: int):
	var panel: VBoxContainer = panel_scene.instance()
	panel.name = str(player_id)
	panel.player_id = player_id
	panel.player_name = Network.names[player_id]
	player_panels[player_id] = panel
	container.add_child(panel)

func get_player_health() -> Dictionary:
	var player_health: Dictionary = {}
	for player in player_panels.keys():
		player_health[player] = player_panels[player].health
	return player_health

func _on_action_manager_new_player_damage(player_damage: Dictionary):
	for player in player_damage:
		var panel: Node = player_panels[player]
		panel.set_health(panel.health - player_damage[player])
	get_parent().new_player_health(get_player_health())
