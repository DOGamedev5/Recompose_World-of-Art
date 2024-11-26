class_name PlayerHud extends CanvasLayer

onready var healthBarr = $container/HUD/HBoxContainer/TextureProgress
onready var animationTreeEye = $container/HUD/HBoxContainer/TextureRect2/AnimationTree
onready var playbackEye = animationTreeEye["parameters/playback"]
onready var cinematic := $cinematic
onready var transition = $transition
onready var dialog := $dialog
onready var HUD := $container/HUD

var currentScreen := "HUD"

func init():
	healthBarr.max_value = Global.player.MAXHEALTH
	healthBarr.value = Global.player.health

	var _1 = Global.player.connect("damaged", self, "hitted")

func _process(_delta):
	if Global.world.clock:
		$Control2.visible = true
		
		var text := ""
		
		if Global.world.timer.time_left / 60 > 0:
			text += String(int(Global.world.timer.time_left / 60))
			text += ":"
			$Control2/TextureRect/Label["custom_colors/font_color"] = Color8(217, 232, 215)
			$Control2/TextureRect/Label["custom_fonts/font"]["outline_color"] = Color8(65, 85, 139)
		else:
			text += "0:"
			$Control2/TextureRect/Label["custom_colors/font_color"] = Color.red
			$Control2/TextureRect/Label["custom_fonts/font"]["outline_color"] = Color(0.5, 0.05, 0.2)
		
		text += "%02d" % (int(floor(Global.world.timer.time_left)) % 60)
		$Control2/TextureRect/Label.text = text
		
	else:
		$Control2.visible = false

func setHealthMax(healthMax):
	healthBarr.max_value = healthMax

func hitted(_direction):

	playbackEye.travel("DAMAGED")

func setHealth(currentValue):
	healthBarr.value = currentValue

func _on_inventoryButton_pressed():
	$inventory.visible = true
	$HUD.visible = false
	
	currentScreen = "INVENTORY"
