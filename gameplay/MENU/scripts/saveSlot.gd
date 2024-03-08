extends Node

export var saveID := 1

const dirSavePath = "user://save%d"

onready var tween = $Tween

var save
var savePath

onready var room := preload("res://worlds/paintWorld/level1.tscn")

func _ready():
	
	savePath = "user://save%d.json" % saveID
	
	$VBoxContainer/Label.text = "SAVE " + str(saveID)
	
	var _1 = $VBoxContainer/play.connect("pressed", self, "_on_Play_pressed")
	var _2 = $VBoxContainer/erase.connect("pressed", self, "_on_Erase_pressed")
	
	

func _on_Play_pressed():
	Global.loadData(savePath)
	
	var _1 = get_tree().change_scene_to(room)

func _on_Erase_pressed():
	Global.saveData(savePath, SaveResource.new())

func visibility_changed():
	if self.visible:
		tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.8,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	else:
		tween.interpolate_property(self, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
	
	tween.start()
