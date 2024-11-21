extends State


func process_physics(_delta):
	var direction : Vector2 = (Global.player.global_position - parent.global_position).normalized()
	
	parent.motion = direction * parent.MAXSPEED

