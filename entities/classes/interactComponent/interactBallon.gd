tool
class_name InteractBallon extends Control

export(NodePath) var areaInteractPath
export(Array, String) var content = [] setget changed
export var showArroy := true

onready var ballon = $ballonContent/ballon
onready var arrow = $arrow
onready var tween = $Tween

var areaInteract : Area2D

var canInteract := false

var player : PlayerBase = null

signal interacted()
signal exitered()
signal entered()

onready var font := preload("res://entities/classes/interactComponent/text.tscn")

func _ready():
	areaInteract = get_node_or_null(areaInteractPath)
	
	arrow.visible = showArroy
	
	var _1 = areaInteract.connect("area_entered", self, "enteredArea")
	var _2 = areaInteract.connect("area_exited", self, "exitedArea")

func _input(_event):
	if Input.is_action_just_pressed("interact") and canInteract:
		emit_signal("interacted")

func enteredArea(area2D):
	if not area2D.is_in_group("player"): return
	if Global.options.colorEffect:
		$ballonContent/ballon.modulate.a = 0.77
	else:
		$ballonContent/ballon.modulate.a = 0.9
	
	player = area2D.get_parent()
	
	emit_signal("entered")
	
	canInteract = true
	arrow.visible = true
	arrow.modulate.a8 = 198
	
	if tween.is_inside_tree():
		tween.stop_all()
		
		tween.interpolate_property($ballonContent, "rect_scale", $ballonContent["rect_scale"], Vector2(1, 1), 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()

func exitedArea(area2D):
	if not area2D.is_in_group("player"): return
	
	emit_signal("exitered")
	player = null
	canInteract = false
	
	if tween.is_inside_tree():
		tween.interpolate_property($ballonContent, "rect_scale", $ballonContent["rect_scale"], Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_OUT, 1.2)
		tween.start()
	
func changed(value):
	content = value
	
	for item in content:
		if item.begins_with("/btn:"):
			var newButton := ControllerTextureRect.new()
			newButton.path = item.substr(5)
			$ballonContent/ballon/MarginContainer/HBoxContainer.add_child(newButton)
		else:
			var newLabel = load("res://entities/classes/interactComponent/text.tscn").instance()
			newLabel.text = item
			$ballonContent/ballon/MarginContainer/HBoxContainer.add_child(newLabel)
	
