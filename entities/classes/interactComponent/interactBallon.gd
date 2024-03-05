class_name InteractBallon extends Control

export(NodePath) var areaInteractPath

onready var ballon = $ballonContent/ballon
onready var arrow = $arrow
onready var ballonText = $ballonContent/ballon/text
onready var tween = $Tween

export var text := "EA" setget changed

var areaInteract : Area2D

var canInteract := false

signal interacted

func _ready():
	
	areaInteract = get_node(areaInteractPath)
	
	var _1 = areaInteract.connect("area_entered", self, "enteredArea")
	var _2 = areaInteract.connect("area_exited", self, "exitedArea")
#	var _3 = connect("script_changed", self, "changed")
	setSize()

func _input(_event):
	if Input.is_action_just_pressed("interact") and canInteract:
		emit_signal("interacted")

func enteredArea(area2D):
	if not area2D.is_in_group("player"): return
	
	canInteract = true
	arrow.modulate.a8 = 198
	
	if tween.is_inside_tree():
		if tween.is_active(): tween.stop($ballonContent, "rect_scale")
		
		tween.interpolate_property($ballonContent, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	

func exitedArea(area2D):
	if not area2D.is_in_group("player"): return
	
	canInteract = false
	arrow.modulate.a8 = 111
	if tween.is_inside_tree():
		if tween.is_active(): tween.stop($ballonContent, "rect_scale")
		
		tween.interpolate_property($ballonContent, "rect_scale", Vector2(1, 1), Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_IN_OUT)
		tween.start()
	
func changed(value):
	$ballonContent/ballon/text.text = value
	
func setSize():
	var size = $ballonContent/ballon/text.rect_size.x
	
	$ballonContent/ballon.rect_position.x = -((size+8)/2)
	$ballonContent/ballon.rect_size.x = size+8
	
	
