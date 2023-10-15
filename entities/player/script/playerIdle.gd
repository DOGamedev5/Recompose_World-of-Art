extends "res://entities/player/script/player.gd"

# Called when the node enters the scene tree for the first time.
static func physics_process(player, delta):
	if Input.get_axis("ui_left", "ui_right"):
		player.currentState = "run"

	if player.can_jump and Input.is_action_pressed("ui_jump"):
		player.currentState = "jump"

	if not player.is_on_floor():
		player.currentState = "jump"
	
