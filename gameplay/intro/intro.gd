extends CanvasLayer

onready var menu = preload("res://gameplay/MENU/menu.tscn")

func _input(_event):
	if Input.is_key_pressed(KEY_ENTER):
		var _1 = get_tree().change_scene_to(menu)

func _on_AnimationPlayer_animation_finished(anim_name):
	var _1 = get_tree().change_scene_to(menu)
