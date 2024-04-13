extends CanvasLayer

onready var menu = preload("res://gameplay/MENU/menu.tscn")

func _on_VideoPlayer_finished():
	var menuInstance = menu.instance()
	
	var _1 = get_tree().change_scene("res://gameplay/MENU/menu.tscn")
