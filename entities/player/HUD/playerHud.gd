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

onready var fragments := $container/HUD/fragments
onready var fragmentsList := $container/HUD/fragments/TextureRect/MarginContainer/GridContainer
onready var tweenFragments := $container/HUD/fragments/Tween

var currentScreen := "HUD"

func _ready():
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
		if Global.world.timer.time_left / 60 > 0:
			text += String(int(Global.world.timer.time_left / 60))
			text += ":"
			timerLabel["custom_colors/font_color"] = Color8(217, 232, 215)
			timerLabel["custom_fonts/font"]["outline_color"] = Color8(65, 85, 139)
		else:
			text += "0:"

		if int(Global.world.timer.time_left / 60) == 0:
			timerLabel["custom_colors/font_color"] = Color.red
			timerLabel["custom_fonts/font"]["outline_color"] = Color(0.5, 0.05, 0.2)

		text += "%02d" % (int(floor(Global.world.timer.time_left)) % 60)
		timerLabel.text = text

func clockInit():
	$Tween.interpolate_property(timer, "margin_top", 56, -61, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.interpolate_property(timer, "margin_bottom", 117, 0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	timer.visible = true

func setHealthMax(healthMax):
	healthBarr.max_value = healthMax

func hitted(_direction):
	playbackEye.travel("DAMAGED")

func setHealth(currentValue):
	healthBarr.value = currentValue

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
