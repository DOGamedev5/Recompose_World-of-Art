extends Node2D

var hasCollected := false
export var collectID := 0

onready var collectTexture := $Sprite

func _ready():
	collectTexture.texture = Global.world.fragmentsTextures[collectID]

func collected():
	if hasCollected: return
	hasCollected = true
	$AnimationPlayer.play("open")
	
	Network.callRemote("collected", get_path())
