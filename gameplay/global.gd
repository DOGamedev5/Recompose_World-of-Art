extends Node

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < 0.000001

func _input(event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()
