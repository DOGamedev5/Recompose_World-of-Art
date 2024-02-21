extends Node

export var saveID := 1
var save

onready var room := preload("res://worlds/paintWorld/level1.tscn")

func _ready():
	save = load("res://gameplay/saves/data/save%d.tres" % saveID)
	
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")

func _on_Play_pressed():
	Global.save = save

func _on_Erase_pressed():
	var emptySlot = SaveResource.new()
	print(save.player)
	
#	save.player = emptySlot.player
	print(save.player)
#	save.world = emptySlot.world
