extends Control

onready var tween := $Tween

onready var caveWorld := "res://worlds/paintWorld/world.tscn"
var selectedWorld : String

func _ready():
	Network.sendP2PPacket(-1, {"type" : "startGame"}, 2)
	Network.connect("worldSelected", self, "worldSelect")

func _exit():
	tween.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 0), Color.white, 0.6, Tween.TRANS_CUBIC)
	tween.start()
	$ColorRect.visible = true
	get_tree().root.set_disable_input(true)

func _on_CaveWorld_pressed():
	if Network.is_host():
		_exit()
		selectedWorld = caveWorld

func _exit_tree():
	get_tree().root.set_disable_input(false)

func _on_Tween_tween_completed(_object, _key):
	LoadSystem.openScreen()
	Network.sendP2PPacket(-1, {"type" : "selectedWorld", "world" : selectedWorld}, 2)
	worldSelect(selectedWorld)

func worldSelect(world):
	LoadSystem.addToQueueChangeScene(world)
	

