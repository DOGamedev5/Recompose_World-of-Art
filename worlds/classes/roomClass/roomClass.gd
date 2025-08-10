class_name RoomClass extends Node2D

export var ID := 0

export(Array, NodePath) var limitsAreas := []

func _ready():
	if not get_node_or_null("enemies"):
		var enemies := Node2D.new()
		enemies.name = "enemies"
		add_child(enemies)
