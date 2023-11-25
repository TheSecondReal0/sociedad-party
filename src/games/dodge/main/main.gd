extends Node3D

var players: Array[Player]
var player_ids: Array[int]

@export var player_scene: PackedScene = preload("res://games/dodge/player/player.tscn")

var spawn: Vector3

# Called when the node enters the scene tree for the first time.
func _ready():
	spawn = $spawn.global_position
	spawn_players()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

@rpc func spawn_players():
	player_ids = Network.get_peers()
	for p in players:
		p.queue_free()
	for p in player_ids:
		player_scene.instantiate(p)
		
