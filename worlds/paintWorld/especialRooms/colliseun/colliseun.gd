extends Node2D

onready var trigger := $Area2D/CollisionShape2D
onready var anim = $AnimationPlayer
onready var metaint = $metaint

var player : PlayerBase

func _ready():
	
	AudioManager.stop()
	var _1 = get_parent().get_parent().connect("changedRoom", self, "exited")
	
	if Global.save.world["paintWorld"].has("metaint") and Global.save.world["paintWorld"]["metaint"] == true:
		trigger.disabled = true
		metaint.queue_free()
	else:
		AudioManager.stop()
		Global.save.world["paintWorld"]["metaint"] = false

func _on_Area2D_area_entered(area):
	if area.is_in_group("player"):
		player = area.get_parent()
		player.setCutscene(true)
		anim.play("cutscene")


func _on_animation_finished(_anim_name):
	trigger.disabled = true
	player.camera.current = true
	player.setCutscene(false)


func _on_metaint_defeated(_enemy):
	Global.save.world["paintWorld"]["metaint"] = true
	$StaticBody2D/CollisionShape2D3.disabled = true

func exited():
	AudioManager.playMusic("paintCaverns")
