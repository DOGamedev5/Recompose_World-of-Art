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
