class_name PathBase extends Area2D

export(String, FILE, "*.tscn") var roomPath
export(String, DIR) var world = "res://worlds/paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export var warpID := 0
var warpType := "warp"

func _ready():
	collision_layer = 1024
	collision_mask = 0
	
func changeRoom():
	get_parent().set_process(false)
	var room : Dictionary = Global.world.generateRoomData(roomID, world, category, roomPath, warpID, warpType)
	Global.world.loadRoom(room)
