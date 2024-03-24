extends Node2D

onready var trigger := $Area2D/CollisionShape2D
onready var anim = $AnimationPlayer

var player : PlayerBase


func _on_Area2D_area_entered(area):
	player = area.get_parent()
	player.moving = false
	anim.play("cutscene")


func _on_animation_finished(_anim_name):
	trigger.disabled = true
	player.camera.current = true
	player.moving = true
