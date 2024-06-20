tool
class_name Door extends PathBase

export(int, 0, 1) var frame := 0 setget doorFrame

export var doorID := 0

onready var parent = get_parent()

func _ready():
	if not parent is RoomClass:
		parent = parent.get_parent()
	
func doorFrame(value):
	frame = value
	$CaveDoor.frame = value

func init(player):
	player.global_position = position

func changeRoom():
	get_parent().get_parent().loadRoom(roomData, doorID, "door")
		
