class_name ChangeRoom extends Area2D

export(String) var room
export var warpID := 0

onready var parent = get_parent()

func _ready():
	connect("body_entered", self, "bodyEntered")
#	room = load(roomPath)

func bodyEntered(body):
	if body.is_in_group("player"):
		get_parent().emit_signal("changeRoom", room, warpID)

		
