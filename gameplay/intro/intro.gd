extends CanvasLayer

onready var menu = preload("res://gameplay/MENU/menu.tscn")

func _ready():
	pass

func _input(_event):
	if Input.is_action_just_pressed("ui_accept"):
		var _1 = Global.tree.change_scene_to(menu)

func _on_AnimationPlayer_animation_finished(_anim_name):
	var _1 = Global.tree.change_scene_to(menu)
