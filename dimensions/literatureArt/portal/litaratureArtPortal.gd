extends DimensionPortal

onready var animation = $AnimationPlayer

var rroomData = {
	roomPath = "res://dimensions/literatureArt/rooms/room1.tscn",
	world = "literatureArt",
	category = "rooms",
	ID = 0
}

func _on_interactBallon_entered():
	animation.play("open")

func _on_interactBallon_exitered():
	animation.play_backwards("open")

func _on_interactBallon_interacted():
	get_parent().get_parent().loadRoom(roomData)
