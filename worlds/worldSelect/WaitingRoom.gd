extends LevelClass

onready var tween := $Tween
onready var totalText := $hud/MarginContainer/HBoxContainer/Label
onready var worlds := [
	"res://worlds/literatureArt/world.tscn",
	"res://worlds/paintWorld/world.tscn"
]
onready var playerScene := preload("res://entities/player/powerStates/normal/playerNormal.tscn")

var totalReady := 0

var selectedWorld : int = -1

func _ready():
	Network.sendP2PPacket(-1, {"type" : "startGame"}, 2)
	Network.connect("worldSelected", self, "selected")
	Network.connect("newMemberJoined", self, "_newPlayer")
	
	$hud/MarginContainer/HBoxContainer/ready.visible = not Network.is_host()
#	$hud.visible = Network.lobbyID != -1
	
func _process(_delta):
	if Global.currentPlataform == Global.plataforms.ITCHIO:
		totalText.text = tr("_ready_offline")
	elif Network.lobbyMembers.size() > 1:
		totalText.text = tr("_ready_count") % [totalReady, Network.lobbyMembers.size() - 1]
		$worldSelect.already = totalReady
		if selectedWorld != -1 and totalReady == Network.lobbyMembers.size() - 1: exit()
	else:
		totalText.text = tr("_ready_alone")

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

func _on_ready_toggled(button_pressed):
	Network.sendP2PPacket(Network.get_host(), {
		"type" : "objectUpdateCall",
		"method" : "readyCount",
		"objectPath" : get_path(),
		"value" : [button_pressed]
	}, 
	Steam.P2P_SEND_RELIABLE_WITH_BUFFERING)

func readyCount(value : bool):
	if value:
		totalReady += 1
	else:
		totalReady -= 1
