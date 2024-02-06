extends Node

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func freeze(time := 0.15, slow = 0.1):
	Engine.time_scale = slow
	yield(get_tree().create_timer(time * slow), "timeout")
	Engine.time_scale = 1
