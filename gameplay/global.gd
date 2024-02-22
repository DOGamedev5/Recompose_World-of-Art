extends Node

var simpleLight := false

var save : SaveResource
var savePath : String

signal simpleLightChanged(value)

func _ready():
	var _1 = connect("simpleLightChanged", self, "_setSimpleLight")	

func _setterSimpleLight(value):
	simpleLight = value
	emit_signal("simpleLightChanged", value)

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func setupPlayer(player):
	player.position = save.player["position"]

func _setSimpleLight(value):
	
	simpleLight = value
