class_name LevelClass extends Node2D

export var firstRoom := ""

var currentRoom
var player

signal changeRoom(room, warpID)

func _ready():
	connect("changeRoom", self, "loadRoom")
	player = load("res://entities/player/powerStates/normal/playerNormal.tscn").instance()
	add_child(player)
	call_deferred("loadRoom",firstRoom)
	

func loadRoom(room : String, warpID := 0):
	if currentRoom:
		currentRoom.queue_free()
	currentRoom = load(room).instance()
	call_deferred("add_child", currentRoom)
	currentRoom.init(player, warpID)
