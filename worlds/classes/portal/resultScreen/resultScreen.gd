extends CanvasLayer

onready var tween := $Tween
onready var content := $content
onready var fragmentsList := $content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect/MarginContainer/GridContainer
onready var fragments := [
	$"content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect/MarginContainer/GridContainer/1",
	$"content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect/MarginContainer/GridContainer/2",
	$"content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect/MarginContainer/GridContainer/3",
	$"content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect/MarginContainer/GridContainer/4"
]
onready var fragmentsBadge := $content/MarginContainer/HBoxContainer/VBoxContainer2/TextureRect
onready var yourPoints := $content/MarginContainer/HBoxContainer/VBoxContainer/yourPoints
onready var counter := $content/MarginContainer/HBoxContainer/VBoxContainer/counter
onready var counterValue := $content/MarginContainer/HBoxContainer/VBoxContainer/counter/points
onready var info := $content/MarginContainer/HBoxContainer/VBoxContainer/info
onready var infoNames := $content/MarginContainer/HBoxContainer/VBoxContainer/info/VBoxContainer/HBoxContainer2/names
onready var infoPoints := $content/MarginContainer/HBoxContainer/VBoxContainer/info/VBoxContainer/HBoxContainer2/points
onready var buttons := $content/MarginContainer/HBoxContainer/VBoxContainer/buttons
onready var updateInfo := $Timer

onready var showStage := 0

func _ready():
	visible = false
	$content/MarginContainer/HBoxContainer/VBoxContainer/buttons/finish.visible = Network.is_host()

func _input(event):
	tween.playback_speed = 1
	if not visible: return
	
	if event.is_action_pressed("interact"):
		tween.playback_speed = 2

func initFragment():
	for i in range(4):
		fragments[i].texture["atlas"] = Global.world.fragmentComplete

func showResults():
	initFragment()
	Global.player.set_process(false)
	Global.player.set_physics_process(false)
	Global.player.pause_mode = 1
	Global.player.visible = false
	
	content.modulate = Color(1, 1, 1, 0)
	Global.playerHud.visible = false
	visible = true
	tween.interpolate_property(content, "modulate", Color(1, 1, 1, 0), Color.white, 0.4, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()

func _on_Tween_tween_all_completed():
	if showStage == 0:
		showFragmentsCollected()
		showStage += 1

	elif showStage == 1:
		showCounter()
		showStage += 1
	
	elif showStage == 2:
		updateInfo.start()
		showInfo()
		showStage += 1
		
	elif showStage == 3:
		buttons.show()
		$content/MarginContainer/HBoxContainer/VBoxContainer/buttons/ready.grab_focus()
		showStage += 1

func showFragmentsCollected():
	var collected : Array = Global.world.collectedFragments.keys()
#	var tree := get_tree()
	
	fragmentsBadge.rect_scale = Vector2(2, 2)
	tween.interpolate_property(fragmentsBadge, "rect_scale", Vector2(2, 2), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.2)
	
	for i in range(collected.size()):
		tween.interpolate_property(fragments[collected[i]], "rect_scale", Vector2(2, 2), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, i*0.7 + 0.4)
#		tree.create_timer(i*1.2 + 0.2).connect("timeout", self, "fragmentsShowTimer", [collected[i]])
	
	tween.start()

func fragmentsShowTimer(fragmentID : int):
	for i in range(fragmentID):
		fragments[i].modulate = Color.white
		fragments[i].show_behind_parent = false

func showCounter():
	tween.interpolate_property(yourPoints, "rect_scale", Vector2(2, 2), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.4)
#	yourPoints.rect_rotation = rand_range(-1.5, 0.2)
	tween.interpolate_property(yourPoints, "rect_rotation", -8, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.4)
	
#	counter.rect_rotation = rand_range(-1.5, 1.5)
	tween.interpolate_property(counter, "rect_scale", Vector2(2, 2), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.7)
	tween.interpolate_property(counter, "rect_rotation", 12, 0, 0.5, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 0.7)
#	tween.interpolate_property(counterValue, "text", "0".pad_zeros(10), str(Players.getPoints()).pad_zeros(10), 1, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.8)
	tween.interpolate_method(self, "setPoints", 0, Players.getPoints(), 0.7, Tween.TRANS_LINEAR, Tween.EASE_IN, 0.8)
	
	tween.start()

func showInfo():
	info.modulate = Color(1, 1, 1, 0)
	info.visible = true
	tween.interpolate_property(info, "modulate", Color(1, 1, 1, 0), Color.white, 0.4, Tween.TRANS_LINEAR, Tween.EASE_OUT, 0.1)
	
	tween.start()

func _on_Tween_tween_started(object, _key):
	if object in fragments:
		object.modulate = Color.white
		object.show_behind_parent = false
	
	object.visible = true

func setPoints(value):
	counterValue.text = str(value).pad_zeros(10)

func _on_Timer_timeout():
	var values := {}
	for player in Players.playerList.keys():
		values[Players.playerList[player].points] = player
	
	var ranking := values.keys().duplicate()
	ranking.sort()
	ranking.invert()
	
	var names := ""
	var points := ""
	
	for i in ranking:
		points += str(i).pad_zeros(10) + "\n"
		names += Network.getPersona(values[i]) + ":\n"
	
	infoNames.text = names
	infoPoints.text = points

func _on_finish_pressed():
	LoadSystem.openScreen()
	LoadSystem.addToQueueChangeScene("res://worlds/worldSelect/WaitingRoom.tscn")
