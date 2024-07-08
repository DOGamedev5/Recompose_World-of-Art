extends Node2D

func _ready():
	var textureName = Global.currentRoom.world.get_file()
	$Ladder.texture = load("res://objects/ladder/sprites/%s.pxo" % (textureName))
