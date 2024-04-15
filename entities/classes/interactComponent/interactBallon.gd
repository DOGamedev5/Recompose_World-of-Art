class_name InteractBallon extends Control

export(NodePath) var areaInteractPath

onready var ballon = $ballonContent/ballon
onready var arrow = $arrow
onready var ballonText = $ballonContent/ballon/text
onready var tween = $Tween

export var text := "EA" setget changed

var areaInteract : Area2D

var canInteract := false

var player : PlayerBase = null

signal interacted(player)
signal exitered(player)
signal entered(player)

func _ready():
	
	areaInteract = get_node(areaInteractPath)
	
	var _1 = areaInteract.connect("area_entered", self, "enteredArea")
	var _2 = areaInteract.connect("area_exited", self, "exitedArea")

	setSize()

func _input(_event):
	if Input.is_action_just_pressed("interact") and canInteract:
		emit_signal("interacted", player)

func enteredArea(area2D):
	if not area2D.is_in_group("player"): return
	
	player = area2D.get_parent()
	
	emit_signal("entered", player)
	
	canInteract = true
	arrow.modulate.a8 = 198
	
	if tween.is_inside_tree():
		if tween.is_active(): tween.stop($ballonContent, "rect_scale")
		
		tween.interpolate_property($ballonContent, "rect_scale", $ballonContent["rect_scale"], Vector2(1, 1), 0.5,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
		tween.start()
	

func exitedArea(area2D):
	if not area2D.is_in_group("player"): return
	
	
	emit_signal("exitered", player)
	player = null
	
	canInteract = false
	arrow.modulate.a8 = 111
	if tween.is_inside_tree():
		tween.interpolate_property($ballonContent, "rect_scale", $ballonContent["rect_scale"], Vector2(0, 0), 0.8,
		Tween.TRANS_EXPO, Tween.EASE_OUT)
		tween.start()
	
func changed(value):
	$ballonContent/ballon/text.set_deferred("text", value)
	call_deferred("setSize")
	
func setSize():
	var lenghtText = $ballonContent/ballon/text.text.length()
	var size = lenghtText * 14 + (lenghtText - 1) * 3
	

	$ballonContent/ballon.rect_position.x = -((size)/2) -8
	print($ballonContent/ballon.rect_position.x)
	print(lenghtText)
	print(size)
	$ballonContent/ballon.rect_size.x = size+8
	
	
