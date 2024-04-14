extends CanvasLayer

onready var menu = "res://gameplay/MENU/menu.tscn"
onready var video = $VideoPlayer

func _process(delta):
	print(video.stream_position)

func _input(event):
	if Input.is_key_pressed(KEY_ENTER) and video.stream_position < 4.4:
		video.set_stream_position(4.4)
		

func _on_VideoPlayer_finished():
	var _1 = get_tree().change_scene(menu)
