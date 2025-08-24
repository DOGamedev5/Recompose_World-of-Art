extends Node2D

var hasCollected := false
export var collectID := 0

onready var collectTexture := $Sprite

func _ready():
	if Global.world.fragmentsTextures.size() > collectID:
		collectTexture.texture = Global.world.fragmentsTextures[collectID]

func collected():
	collect()
	Network.callRemote("collect", get_path(), [Network.steamID])

func collect(id := Network.steamID):
	if hasCollected: return
	hasCollected = true
	$AnimationPlayer.play("open")
	Global.world.collect(collectID, id)
