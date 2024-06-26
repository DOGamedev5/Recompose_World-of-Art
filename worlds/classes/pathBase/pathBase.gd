class_name PathBase extends Area2D

export(String, FILE, "*.tscn") var roomPath
export(String, DIR) var world = "res://worlds/paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export var warpID := 0

var roomData : RoomData

func _ready():
	set_collision_layer_bit(10, true)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(0, false)
	
	roomData = RoomData.new(roomID, world, category, roomPath, warpID, "warp")
	
func changeRoom():
	get_parent().get_parent().loadRoom(roomData)
