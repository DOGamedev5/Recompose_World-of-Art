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

func _ready():
	animationPlayer = get_node(animationPlayerPath)
	camera = get_node(cameraPath)
	
	camera["limit_left"] = get_parent().limitsMin.x
	camera["limit_top"] = get_parent().limitsMin.y
	camera["limit_right"] = get_parent().limitsMax.x
	camera["limit_bottom"] = get_parent().limitsMax.y
	
	var _1 = connect("area_entered", self, "areaEntered")

func areaEntered(area):
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal") == normalFilter):
		return
	
	Global.player.setCinematic(true)
	
	camera.current = true
	var oldPlayer = Global.player
	oldPlayer.visible = false
	
	if animationPlayer is AnimationPlayer:
		animationPlayer.play(animation)
		yield(animationPlayer, "animation_finished")
	else:
		var playback : AnimationNodeStateMachinePlayback = animationPlayer["parameters/playback"]
		playback.travel(animation)
		yield(get_tree().create_timer(animationTime), "timeout")
	
	Global.player = load(transformation).instance()
	oldPlayer.queue_free()
	Global.world.add_child(Global.player)
	
	Global.player.global_position = global_position + offset
	
	Global.playerHud.cinematic.desactivaded()
