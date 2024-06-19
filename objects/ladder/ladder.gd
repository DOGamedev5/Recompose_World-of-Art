extends Node2D

export(String, "artificial", "paint") var texture = "paint"

func _ready():
	$Ladder.texture = load("res://objects/ladder/sprites/%s.pxo" % (texture))
