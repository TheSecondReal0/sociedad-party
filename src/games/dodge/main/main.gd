extends Node3D

var object_resources: Array[DodgeResource] = []

# Called when the node enters the scene tree for the first time.
func _ready():
	var resources: Array = Helpers.load_files_in_dir_with_exts("res://games/dodge/objects", [".tres"])
	for res in resources:
		print(res.name)
		object_resources.append(res)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
