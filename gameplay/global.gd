extends Node

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < 0.000001

