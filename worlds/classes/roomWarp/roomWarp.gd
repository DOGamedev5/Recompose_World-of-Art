class_name RoomWarp extends Position2D

export var fixed_X := true
export var fixed_Y := true
export var offset_X := .0
export var offset_Y := .0

func init(player):
	if fixed_X or Global.currentRoom.debugMode:
		player.global_position.x = position.x 
	else:
		player.global_position.x += offset_X
		
	if fixed_Y or Global.currentRoom.debugMode:
		player.global_position.y = position.y
	else:
		player.global_position.y += offset_Y
