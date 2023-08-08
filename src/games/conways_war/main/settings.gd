extends VBoxContainer


enum SETTING_TYPES {BOOL, INT_RANGE, FLOAT_RANGE}
enum KEYS {TYPE, RANGE, DEFAULT, DESC}

var bool_scene: PackedScene = load("res://games/conways_war/ui/setting_scenes/bool/bool.tscn")
var int_range_scene: PackedScene = load("res://games/conways_war/ui/setting_scenes/int_range/int_range.tscn")

onready var main: Node2D = get_node("../../..")

#	config.reproduce_threshold = 2
#	config.starve_threshold = 1
#	config.overpop_threshold = 6
#	config.convert_to_fighters = true
#	config.convert_to_fighter_max = 2
#	config.fighter_overpop_threshold = 8
#	config.fighter_repro_mod_factor = 1.0
#	config.convert_to_defenders = true
#	config.convert_to_defender_normal_adj = 2
#	config.defender_max_normal_adj = 8
#	config.defender_repro_mod_factor = 1.0

var settings: Dictionary = {
	"reproduce_threshold":		{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [1,8],
								KEYS.DEFAULT: 2,
								KEYS.DESC: "If this many or more of your tiles are adjacent to an empty square, you will spread to it"},
	"starve_threshold":			{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [1,8],
								KEYS.DEFAULT: 1,
								KEYS.DESC: "If one of your tiles is adjacent to this many or less of your tiles, it will die"},
	"overpop_threshold":		{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [1,8],
								KEYS.DEFAULT: 5,
								KEYS.DESC: "If one of your tiles is adjacent to this many or more of your tiles, it will die"},
	
	"convert_to_fighters":		{KEYS.TYPE: SETTING_TYPES.BOOL,
								KEYS.DEFAULT: false,
								KEYS.DESC: "Whether or not your tiles can convert to fighters\n\nFighters count as 2 normal tiles during offense and discourage enemies from reproducing into adjacent tiles"
								},
	"convert_to_fighter_max":	{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [0,8],
								KEYS.DEFAULT: 2,
								KEYS.DESC: "At or below this amount of adjacent fighters (owned by you), one of your normal tiles will convert into a fighter"},
	"fighter_overpop_threshold":{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [1,8],
								KEYS.DEFAULT: 8,
								KEYS.DESC: "At or above this amount of adjacent fighters (owned by you), one of your fighters will die"},
	
	"convert_to_defenders":		{KEYS.TYPE: SETTING_TYPES.BOOL,
								KEYS.DEFAULT: false,
								KEYS.DESC: "Whether or not your tiles can convert to defenders\n\nDefenders count as 2 normal tiles during defense"
								},
	"convert_to_defender_normal_adj":{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [0,8],
								KEYS.DEFAULT: 2,
								KEYS.DESC: "When one of your normal tiles is adjacent to exactly this many other normal tiles (owned by you), it will convert into a defender\n\nDefenders count as 2 normal tiles during offense"},
	"defender_max_normal_adj":	{KEYS.TYPE: SETTING_TYPES.INT_RANGE, 
								KEYS.RANGE: [1,8],
								KEYS.DEFAULT: 8,
								KEYS.DESC: "When one of your defenders is adjacent to this many or more normal tiles (owned by you), it will die"},
}



# Called when the node enters the scene tree for the first time.
func _ready():
	create_settings()

func get_default_config() -> ConwayConfig:
	var config: ConwayConfig = ConwayConfig.new()
	for setting in settings:
		config.set(setting, settings[setting][KEYS.DEFAULT])
	return config

func setting_changed() -> void:
	#print("settings setting changed")
	main.settings_changed(get_setting_values())

func get_setting_values() -> Dictionary:
	var dict: Dictionary = {}
	for node in get_children():
		dict[node.name] = node.get_value()
	return dict

func create_settings() -> void:
	for setting in settings:
		setting = setting as String
		var options: Dictionary = settings[setting]
		var node: Control
		match options[KEYS.TYPE]:
			SETTING_TYPES.BOOL:
				node = bool_scene.instance()
				node.name = setting
				add_child(node)
			SETTING_TYPES.INT_RANGE:
				node = int_range_scene.instance()
				node.name = setting
				add_child(node)
				node.set_range(options[KEYS.RANGE][0], options[KEYS.RANGE][1])
		node.set_text(setting.capitalize())
		node.set_value(options[KEYS.DEFAULT])
		node.set_tooltip(options[KEYS.DESC])
		node.connect("changed", self, "setting_changed")
