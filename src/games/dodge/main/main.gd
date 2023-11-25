extends Node3D

var players: Array[Player]
var player_ids: Array

@export var player_scene: PackedScene = preload("res://games/dodge/player/player.tscn")

var spawn: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn = $spawn.global_position
	spawn_players()
	rpc("spawn_players")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc func spawn_players():
	player_ids = Network.get_peers()
	print(player_ids)
	for p in players:
		p.queue_free()
	for id in player_ids:
		var new_player = player_scene.instantiate(id)
		new_player.id = id
		new_player.name = str(id)
		self.add_child(new_player)
		new_player.global_position = spawn
		players.append(new_player)
		print(new_player.id)
