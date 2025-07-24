extends LevelClass

onready var tween := $Tween
onready var worlds := ["res://worlds/paintWorld/world.tscn"]
onready var playerScene := preload("res://entities/player/powerStates/normal/playerNormal.tscn")

var selectedWorld : int

func _ready():
	Network.sendP2PPacket(-1, {"type" : "startGame"}, 2)
	Network.connect("worldSelected", self, "selected")
	Network.connect("newMemberJoined", self, "_newPlayer")

func exit(world := selectedWorld):
	if Network.is_host():
		Network.sendP2PPacket(-1, {"type" : "selectedWorld", "world" : world}, 2)
	
	$CanvasLayer.visible = true
	tween.interpolate_property($CanvasLayer/ColorRect, "modulate", Color(1, 1, 1, 0), Color.white, 0.6, Tween.TRANS_CUBIC)
	tween.start()
	get_tree().root.set_disable_input(true)

func _newPlayer(id):
	var newPlayer := playerScene.instance()
	newPlayer.OwnerID = id
	newPlayer.global_position = $RoomWarp.global_position
	add_child(newPlayer)
	Players.addPlayer(id, newPlayer)

func worldSelect(world):
	LoadSystem.addToQueueChangeScene(worlds[world])

func _on_Tween_tween_completed(object, _key):
	if object == $CanvasLayer/ColorRect:
		LoadSystem.openScreen()
		worldSelect(selectedWorld)

func _exit_tree():
	get_tree().root.set_disable_input(false)
