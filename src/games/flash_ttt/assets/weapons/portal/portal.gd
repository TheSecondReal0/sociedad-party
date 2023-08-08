extends Node2D

func _ready():
	$Camera2D.custom_viewport = $Viewport
	$Camera2D.current = true
