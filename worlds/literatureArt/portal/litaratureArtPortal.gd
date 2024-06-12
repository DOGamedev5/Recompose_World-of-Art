extends Node

onready var animation = $AnimationPlayer

var roomData = {
	roomPath = "res://worlds/literatureArt/rooms/room1.tscn",
	world = "literatureArt",
	category = "rooms",
	ID = 0
}

func _on_interactBallon_entered(_player):
	animation.play("open")

func _on_interactBallon_exitered(_player):
	animation.play_backwards("open")

func _on_interactBallon_interacted(_player):
	get_parent().get_parent().loadRoom(roomData, 0, "warp")
