class_name TransformClass extends Area2D

export(String, FILE, "*.tscn") var transformation
export(String) var animation
export(float) var animationTime
export(NodePath) var animationPlayerPath
export var offset := Vector2.ZERO
export var normalFilter := true
var animationPlayer


func _ready():
	animationPlayer = get_node(animationPlayerPath)
	var _1 = connect("area_entered", self, "areaEntered")

func areaEntered(area):
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal") == normalFilter):
		return
	
	Global.player.setCinematic(true)
	Global.player.global_position = global_position + offset
	Global.player.visible = false
	if animationPlayer is AnimationPlayer:
		animationPlayer.play(animation)
		yield(animationPlayer, "animation_finished")
	else:
		var playback : AnimationNodeStateMachinePlayback = animationPlayer["parameters/playback"]
		playback.travel(animation)
		yield(get_tree().create_timer(animationTime), "timeout")
	
	Global.player.changePowerup(transformation)
	Global.playerHud.cinematic.desactivaded()
