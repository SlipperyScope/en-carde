@icon("res://Andrew/Platinum/Misc/P_Icon_Rule.png")

## Keeps track of the current game. Use this for information all players might use
class_name P_GameState extends P_Resource


var _StartTime: float = -1

## Time at the start of the match
var StartTime: float:
	get: return _StartTime
	set(_v): push_error("Start Time is read only")


## 
func StartGame() -> void:
	_StartTime = Time.get_ticks_msec() * 1000.0
