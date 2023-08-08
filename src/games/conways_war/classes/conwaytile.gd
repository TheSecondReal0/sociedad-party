extends Reference
class_name ConwayTile

var position: Vector2
var player: int = 0

var type: int = TYPES.NORMAL
enum TYPES {NORMAL, FIGHTER, DEFENDER}



func get_position() -> Vector2:
	return position

func get_player_id() -> int:
	return player

func get_player_name() -> String:
	return Network.get_player_name(player)

func get_color() -> Color:
	match player:
		2:
			return Color(1.0, 0.0, 0.0)
		3:
			return Color(0.0, 1.0, 0.0)
		4:
			return Color(0.0, 0.0, 1.0)
	return Network.get_color(player)
