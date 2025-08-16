class_name TransformClass extends Area2D

export(String, FILE, "*.tscn") var transformation
export(String) var animation
export(float) var animationTime
export(NodePath) var animationPlayerPath
export(NodePath) var cameraPath
export var offset := Vector2.ZERO

export var normalFilter := true
var animationPlayer
var camera : Camera2D

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)

var beingUsed := false
var whoUsing := -1

func _ready():
	collision_mask = 4096
	
	animationPlayer = get_node(animationPlayerPath)
	if animationPlayer is AnimationPlayer:
		animationPlayer.connect("animation_finished", self, "setup")
	
	camera = get_node(cameraPath)
	
	camera["limit_left"] = int(limitsMin.x + global_position.x)
	camera["limit_top"] = int(limitsMin.y + global_position.y)
	camera["limit_right"] = int(limitsMax.x + global_position.x)
	camera["limit_bottom"] = int(limitsMax.y + global_position.y)
	
	var _1 = connect("area_entered", self, "areaEntered")

func areaEntered(area):
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal") == normalFilter) or beingUsed:
		return
	if not Network.is_owned(area.get_parent().OwnerID):
		return
	
	Network.sendP2PPacket(Network.get_host(), {
		"type" : "objectUpdateCall",
		"method" : "animationStart",
		"objectPath" : get_path(),
		"value" : [Network.steamID]
	},
	Steam.NETWORKING_SEND_RELIABLE)
	
	animationStart(Network.steamID)
	
func animationStart(id):
	beingUsed = true
	whoUsing = id
#	Players.playerList[id].reference.active = false
	Players.playerList[id].reference.pause_mode = 1
	Players.playerList[id].reference.visible = false
	
	if Network.is_owned(id): Global.player.setCinematic(true)
	
	if animationPlayer is AnimationPlayer:
		animationPlayer.play(animation)
	else:
		var playback : AnimationNodeStateMachinePlayback = animationPlayer["parameters/playback"]
		playback.travel(animation)
		get_tree().create_timer(animationTime).connect("timeout", self, "setup")

func setup(_anim:="", id := whoUsing):
	var oldPlayer = Players.playerList[id].reference
	var newPlayer : PlayerBase = LoadedObjects.loaded[transformation].instance()
	
	newPlayer.global_position = global_position + offset
	if Network.steamID == id:
		Global.player = newPlayer

	newPlayer.OwnerID = id
	
	Global.world.add_child(newPlayer)

	newPlayer.owner = Global.world
			
	Players.playerList[id].reference = newPlayer
	oldPlayer.pause_mode = 0
	oldPlayer.queue_free()
	beingUsed = false
#	Global.world.call_deferred("add_child", Global.player)
#	Global.world.call_deferred("setCameraLimits", oldCameraLimits["min"], oldCameraLimits["max"])
	
	Global.playerHud.cinematic.desactivaded()
	
