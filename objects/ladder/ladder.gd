extends Node2D

func _ready():
	if Global.world.alternativeTextures.has("ladder"):
		$Ladder.texture = Global.world.alternativeTextures["ladder"]

