tool
class_name Door extends PathBase

export(int, 0, 1) var frame := 0 setget doorFrame

func _ready():
	roomData.warpType = "door"
	
func doorFrame(value):
	frame = value
	$CaveDoor.frame = value

func init():
	Global.player.global_position = position

func interacted():
	changeRoom()
