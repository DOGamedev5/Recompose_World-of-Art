class_name PathBase extends Area2D

export(String, FILE, "*.tscn") var roomPath
export(String) var world = "paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export var warpID := 0

var roomData : Dictionary

func _ready():
	set_collision_layer_bit(10, true)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(0, false)
	
	if roomID != 0:
		roomPath = "res://worlds/{world}/{category}/room{room}.tscn".format({
			"world" : world,
			"category" : category,
			"room" : roomID
		})
	
	roomData = {
		roomPath = roomPath,
		world = world,
		category = category,
		ID = roomID
	}

func changeRoom():
	get_parent().get_parent().loadRoom(roomData, warpID, "warp")
