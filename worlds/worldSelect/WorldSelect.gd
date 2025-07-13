extends Control

onready var tween := $Tween

onready var worlds := ["res://worlds/paintWorld/world.tscn"]
enum {
	CaveWorld
}
var selectedWorld : int = 0

func _ready():
	Network.sendP2PPacket(-1, {"type" : "startGame"}, 2)
	Network.connect("worldSelected", self, "selected")
	$VBoxContainer/worlds/CaveWorld.connect("pressed", self, "selected", [CaveWorld])
#	$VBoxContainer/worlds/SandWorld.connect("pressed", self, "selected", [SandWorld]) ### <- Coming Soon

func _exit(world := selectedWorld):
	if Network.is_host():
		Network.sendP2PPacket(-1, {"type" : "selectedWorld", "world" : selectedWorld}, 2)
	
	tween.interpolate_property($ColorRect, "modulate", Color(1, 1, 1, 0), Color.white, 0.6, Tween.TRANS_CUBIC)
	tween.start()
	$ColorRect.visible = true
	get_tree().root.set_disable_input(true)

func selected(id):
	_exit()
	selectedWorld = id

func _exit_tree():
	get_tree().root.set_disable_input(false)

func _on_Tween_tween_completed(_object, _key):
	LoadSystem.openScreen()
	
	worldSelect(selectedWorld)

func worldSelect(world):
	LoadSystem.addToQueueChangeScene(worlds[world])
	

