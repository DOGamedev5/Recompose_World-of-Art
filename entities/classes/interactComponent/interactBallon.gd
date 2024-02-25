class_name InteractBallon extends Control

export(NodePath) var areaInteractPath

onready var ballon = $ballon
onready var arrow = $arrow
onready var text = $ballon/text

var areaInteract : Area2D

var canInteract := false

signal interacted

func _ready():
	areaInteract = get_node(areaInteractPath)
	
	var _1 = areaInteract.connect("area_entered", self, "enteredArea")
	var _2 = areaInteract.connect("area_exited", self, "exitedArea")

func _input(_event):
	if Input.is_action_just_pressed("interact") and canInteract:
		emit_signal("interacted")

func enteredArea(area2D):
	if area2D.is_in_group("player"):
		canInteract = true
		ballon.visible = true
		arrow.modulate.a8 = 198

func exitedArea(area2D):
	if area2D.is_in_group("player"):
		canInteract = false
		ballon.visible = false
		arrow.modulate.a8 = 111
	
	
	
