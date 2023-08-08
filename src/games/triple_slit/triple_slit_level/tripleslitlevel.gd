extends Resource

class_name TripleSlitLevel

export (String, MULTILINE) var desc
export var button_amount: int = 10
export var info_template: Dictionary

var alphabet: PoolStringArray = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_level_info_dict() -> Dictionary:
	var dict: Dictionary = {}
	dict["desc"] = desc
	dict["button_amount"] = button_amount
	dict["info_dict"] = generate_values()
	return dict

func generate_values() -> Dictionary:
	var dict: Dictionary = {}
	for info_name in info_template:
		var value_list: Array = info_template[info_name]
		if value_list.size() == 2:
			var num_list: Array = range(value_list[0], value_list[1] + 1)
			dict[info_name] = str(num_list[randi() % num_list.size()])
		else:
			dict[info_name] = str(alphabet[randi() % 26])
	return dict
