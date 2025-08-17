extends Area2D

onready var menu := "res://gameplay/MENU/menu.tscn"
onready var door := $Door
var screenShow := false

func _ready():
	Network.connect("newMemberJoined", self, "doorOpen")
	Network.connect("memberLeft", self, "doorOpen")

func doorOpen(_id):
	$AnimationPlayer.play("doorOpen")

func _animationStep(value := 0):
	if door.frame_coords.x >= 5 and value < 5:
		$AnimationPlayer.seek(0.4)
	door.frame_coords.x = value

func _on_interactBallon_entered():
	door.frame_coords.y = 1

func _on_interactBallon_exitered():
	door.frame_coords.y = 0

func _on_interactBallon_interacted():
	if screenShow: return
	screenShow = true
	Global.player.moving = false
	$confirmExit.show()
	yield(get_tree().create_timer(0.2), "timeout")
	$confirmExit/Panel/margin/VBoxContainer/HBoxContainer/no.grab_focus()

func _on_no_pressed():
	$confirmExit.hide()
	screenShow = false
	Global.player.moving = true

func _on_yes_pressed():
	Network.leaveLobby()
	get_tree().change_scene(menu)
