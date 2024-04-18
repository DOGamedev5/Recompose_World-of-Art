class_name ChangeRoom extends Area2D

export(String, FILE, "*.tscn") var roomPath
export(String) var world = "paintWorld"
export(int) var roomID
export(String, "rooms", "especialRooms") var category = "rooms"

export var warpID := 0

onready var parent = get_parent()

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
		
	monitoring = true

func changeRoom():
	get_parent().get_parent().loadRoom(roomPath, warpID)
		
