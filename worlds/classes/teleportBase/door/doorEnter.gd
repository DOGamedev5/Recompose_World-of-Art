extends TeleportBase

export(int, 0, 1) var frame := 0 setget doorFrame

func doorFrame(value):
	frame = value
	$CaveDoor.frame = value
	
func _ready():
	modulate = Color.white * 1.5 if frame == 1 and Global.options.colorEffect else Color.white

func _on_interactBallon_interacted():
	Global.player.global_position = global_position
	Global.player.motion = Vector2.ZERO
	Global.player.taunt("ENTER")
	Global.playerHud.transition.transitionIn()
	yield(Global.playerHud.transition, "transitionedIn")
	
	teleport()

func init():
	Global.player.global_position = global_position
	Global.world.setCameraLimits(limitsMin + global_position, limitsMax + global_position)
	Global.playerHud.transition.transitionOut()
	Global.player.taunt("EXIT")
	
	for areaPath in areasToUpdate:
		var area = get_node_or_null(areaPath) as Area2D
		if area:
			area.emit_signal("area_entered", Global.player.hitbox)
	
	teleportFinish()
