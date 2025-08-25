class_name PlayerHud extends CanvasLayer

onready var healthBarr = $container/HUD/HBoxContainer/TextureProgress
onready var animationTreeEye = $container/HUD/HBoxContainer/TextureRect2/AnimationTree
onready var playbackEye = animationTreeEye["parameters/playback"]
onready var cinematic := $cinematic
onready var transition = $transition
onready var dialog := $dialog
onready var HUD := $container/HUD
onready var timer := $timer
onready var timerLabel := $timer/TextureRect/Label

onready var counter := $container/HUD/HBoxContainer/PanelContainer/Label
onready var tweenPoints := $container/HUD/HBoxContainer/pointTween
onready var timerPoints := $container/HUD/HBoxContainer/pointTimer

onready var fragments := $container/HUD/fragments
onready var fragmentsList := $container/HUD/fragments/TextureRect/MarginContainer/GridContainer
onready var tweenFragments := $container/HUD/fragments/Tween

var currentScreen := "HUD"

func _ready():
	counter.text = str(0).pad_zeros(10)
	Global.playerHud = self
	if get_parent() is LevelClass:
		get_parent().connect("clockInitialized", self, "clockInit")

func init(player):
	healthBarr.max_value = player.MAXHEALTH
	healthBarr.value = player.health

	var _1 = player.connect("damaged", self, "hitted")

func _process(_delta):
	if Global.world.clock:

		var text := ""
#		
		var minutes := int(Global.world.timer.time_left / 60)
	
#		if minutes > 0:
		text += String(minutes)
		text += ":"
#		else:
#			text += "0:"
		if minutes == 0:
			timerLabel["custom_colors/font_color"] = Color.red
			timerLabel["custom_fonts/font"]["outline_color"] = Color(0.5, 0.05, 0.2)
		else:
			timerLabel["custom_colors/font_color"] = Color8(217, 232, 215)
			timerLabel["custom_fonts/font"]["outline_color"] = Color8(65, 85, 139)
		
		text += "%02d" % (int(floor(Global.world.timer.time_left)) % 60)
		timerLabel.text = text

func clockInit():
	$Tween.interpolate_property(timer, "margin_top", 56, -61, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(timer, "margin_bottom", 117, 0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	timer.visible = true
	timerPoints.start()

func hitted(_direction):
	playbackEye.travel("DAMAGED")

func addPoints(points : int):
	Players.addPoints(points)
	
	counter.text = str(Players.getPoints()).pad_zeros(10)
	tweenPoints.stop_all()
	tweenPoints.interpolate_property(counter, "rect_scale", Vector2(1.15, 1.15), Vector2(1, 1), 0.2, Tween.TRANS_QUART, Tween.EASE_IN)
	var color := Color.white if points > 0 else Color(1, 0.1, 0.2)
	counter["custom_colors/font_color"] = Color(0.99, 0.91, 0.2)
	if points < 0:
		tweenPoints.interpolate_property(counter, "custom_colors/font_color", Color(1, 0.27, 0.27), Color(0.99, 0.91, 0.2), 0.2, Tween.TRANS_QUART, Tween.EASE_IN)
	tweenPoints.interpolate_property(counter["custom_fonts/font"], "outline_color", color, Color(0.16, 0.02, 0.02), 0.2, Tween.TRANS_QUART, Tween.EASE_IN)
	
	tweenPoints.start()

func _on_pointTimer_timeout():
	addPoints(-5)

func finished():
	timerPoints.stop()

func addFragmentsTextures(textures):
	for i in range(textures.size()):
		var fragment := fragmentsList.get_node(str(i + 1))
		
		fragment.texture = textures[i]

func updateFragment(id, got):
	var texture := fragmentsList.get_node(str(id+1))
	
	texture.modulate = Color.white if got else Color(0.13, 0.11, 0.27)
	
	tweenFragments.stop_all()
#	fragments.modulate = Color.white
	tweenFragments.interpolate_property(fragments, "rect_scale", Vector2(1.2, 1.2), Vector2(1, 1), 1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tweenFragments.interpolate_property(fragments, "modulate", fragments.modulate, Color.white, 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tweenFragments.interpolate_property(fragments, "modulate", Color.white, Color(1, 1, 1, 0.2), 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN, 1.2)
	tweenFragments.start()

