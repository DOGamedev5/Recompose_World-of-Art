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

func _ready():
	animationPlayer = get_node(animationPlayerPath)
	camera = get_node(cameraPath)
	
	camera["limit_left"] = int(limitsMin.x + global_position.x)
	camera["limit_top"] = int(limitsMin.y + global_position.y)
	camera["limit_right"] = int(limitsMax.x + global_position.x)
	camera["limit_bottom"] = int(limitsMax.y + global_position.y)
	
	var _1 = connect("area_entered", self, "areaEntered")

func areaEntered(area):
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal") == normalFilter):
		return
	
	Global.player.setCinematic(true)
	
#	camera.current = true
	var oldPlayer = Global.player
	oldPlayer.visible = false
	
	var oldCameraLimits := {
		"min" : Vector2(
			oldPlayer.camera.limit_left,
			oldPlayer.camera.limit_top
		),
		"max" : Vector2(
			oldPlayer.camera.limit_right,
			oldPlayer.camera.limit_bottom
		)
	}
	
	if animationPlayer is AnimationPlayer:
		animationPlayer.play(animation)
		yield(animationPlayer, "animation_finished")
	else:
		var playback : AnimationNodeStateMachinePlayback = animationPlayer["parameters/playback"]
		playback.travel(animation)
		yield(get_tree().create_timer(animationTime), "timeout")
	
	Global.player = LoadedObjects.loaded[transformation].instance()
	Global.player.OwnerID = oldPlayer.OwnerID
	oldPlayer.queue_free()
	Global.player.global_position = global_position + offset
	
	Global.world.call_deferred("add_child", Global.player)
	Global.world.call_deferred("setCameraLimits", oldCameraLimits["min"], oldCameraLimits["max"])
	
	Global.playerHud.cinematic.desactivaded()
