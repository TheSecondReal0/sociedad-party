extends Control

export var show_random: bool = false

var value1: float = randf()
var value2: float = randf()
var value3: float = randf()

var intensity1: float = 0.0
var intensity2: float = 0.0
var intensity3: float =0.0

var order: Array = []

onready var flavor_to_sprite: Dictionary = {"Red Zest": $value1, "Green Tart": $value2, "Blue Crackle": $value3}
var flavor_to_intensity: Dictionary = {"Red Zest": 1, "Green Tart": 2, "Blue Crackle": 3}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	if show_random:
		var rand_flavor_amounts: Dictionary = {"Red Zest": randi() % 20, "Green Tart": randi() % 20, "Blue Crackle": randi() % 20}
		new_flavor_amounts(rand_flavor_amounts)

func set_sprite_scale(scale: int):
	for sprite in flavor_to_sprite.values():
		sprite.scale.x = scale
		sprite.scale.y = scale

func new_flavor_amounts(flavor_amounts: Dictionary):
	for flavor in flavor_to_sprite:
		if flavor in flavor_amounts:
			flavor_to_sprite[flavor].show()
		else:
			flavor_to_sprite[flavor].hide()
	var total_flavor: float = 0
	for value in flavor_amounts.values():
		total_flavor += value
	for i in flavor_amounts.keys().size():
		var flavor: String = flavor_amounts.keys()[i]
		var intensity: int = flavor_to_intensity[flavor]
		flavor_to_sprite[flavor].z_index = i
		flavor_to_sprite[flavor].modulate.a8 = (64 * (3 - i)) - 1
		#print("intensity" + str(intensity), ": ", float(flavor_amounts[flavor]) / total_flavor)
		set("intensity" + str(intensity), float(flavor_amounts[flavor]) / total_flavor)
	
#	var dict: Dictionary = {1: intensity1, 2: intensity2, 3: intensity3}
#	for flavor in flavor_amounts:
#		var num: int = flavor_to_intensity[flavor]
#		var sprite: Sprite = get_node("value" + str(num))
#		sprite.material.set("shader_param/rand_multiplier", dict[num])
	update_profile()

func update_profile():
	var dict: Dictionary = {1: intensity1, 2: intensity2, 3: intensity3}
	for i in dict:
		var sprite: Sprite = get_node("value" + str(i))
		sprite.material.set("shader_param/rand_multiplier", dict[i])
#	var sprite_order: Array = [1, 2, 3]
#	sprite_order.shuffle()
#	var current_sprite: int = 1
#	for i in sprite_order:
#		var sprite: Sprite = get_node("value" + str(current_sprite))
#		current_sprite += 1
#		sprite.z_index = i


func get_order() -> Array:
	var dict: Dictionary = {1: intensity1, 2: intensity2, 3: intensity3}
	print(dict)
	var value_order: Array = [intensity1, intensity2, intensity3]
	value_order.sort()
	value_order.invert()
	print(value_order)
	var new_order: Array = []
	for value in value_order:
		for i in dict:
			if dict[i] == value and not i in new_order:
				new_order.append(i)
	print(new_order)
	return new_order
