class_name ChangeRoom extends Area2D

export(String) var room
export(String) var world = "paintWorld"
export(int) var roomID
export var warpID := 0

onready var parent = get_parent()

func _ready():
	
	set_collision_layer_bit(10, true)
	set_collision_mask_bit(0, false)
	set_collision_layer_bit(0, false)
	
	if roomID != 0:
		room = "res://worlds/{world}/rooms/room{room}.tscn".format({"world" : world, "room" : roomID})
		
	monitoring = true
	

func changeRoom():
	get_parent().emit_signal("changeRoom", room, warpID)
		
