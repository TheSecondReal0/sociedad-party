tool
extends EditorPlugin

#custom resources
var game_info_resource_script

#icons
var object_icon

func _enter_tree():
	pass
	#load custom resources
	#game_info_resource_script = preload("res://addons/apgi/resources/game_info/gameinfo.gd")
	
	#load icons
	#object_icon = preload("res://addons/apgi/icons/object.svg")
	
	#add custom resources
	#add_custom_type("GameInfo", "Resource", game_info_resource_script, object_icon)

func _exit_tree():
	pass
	#remove_custom_type("GameInfo")
