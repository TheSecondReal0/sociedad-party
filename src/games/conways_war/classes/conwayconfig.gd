extends Resource
class_name ConwayConfig

export var reproduce_threshold: int = 3
export var starve_threshold: int = 1
export var overpop_threshold: int = 5

export var convert_to_fighters: bool = true
# max amount of adjacent fighters there can be to convert this tile into fighter
export var convert_to_fighter_max: int = 0
# when there are at least this many fighters adjacent, tile dies
export var fighter_overpop_threshold: int = 5
export var fighter_repro_mod_factor: float = 1.0

export var convert_to_defenders: bool = true
# exact amount of adjacent normal tiles to convert this one into defender
export var convert_to_defender_normal_adj: int = 2
# when there are at least this many normal tiles adjacent, defender dies
export var defender_max_normal_adj: int = 5
export var defender_repro_mod_factor: float = 1.0
