extends Node2D

onready var trigger := $Area2D/CollisionShape2D
onready var anim = $AnimationPlayer
onready var metaint = $metaint
onready var dialog = $dialog

var player : PlayerBase

const dialogText = [
	{"image" : 0, "react" : 0, "text" : "metaint_1", "name" : "Metaint"},
	{"image" : 0, "react" : 0, "text" : "metaint_2", "name" : "Metaint"}
]

func _ready():
	dialog.addDialog(dialogText)
	
#	AudioManager.stop()
	var _1 = get_parent().get_parent().connect("changedRoom", self, "exited")
	
	if Global.save.world["paintWorld"].has("metaint") and Global.save.world["paintWorld"]["metaint"] == true:
		trigger.disabled = true
		metaint.queue_free()
	else:
		AudioManager.stop()
		Global.save.world["paintWorld"]["metaint"] = false

func interact():
	dialog.interacted(player)

func _input(_event):
	if Input.is_action_just_pressed("interact") and dialog.hasInteracted:
		interact()

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		player = area.get_parent()
		player.setCutscene(true)
		anim.play("cutscene")


func _on_cutscene_finished():
	trigger.disabled = true
	metaint.active = true
	player.camera.current = true
	player.setCutscene(false)


func _on_metaint_defeated(_enemy):
	Global.save.world["paintWorld"]["metaint"] = true
	$StaticBody2D/CollisionShape2D3.disabled = true

func exited():
	AudioManager.playMusic("paintCaverns")
