extends State

func enter(_ls):
	
	$Timer.wait_time = rand_range(1.5, 2.5)
	$Timer.start()

func process_physics(_delta):
	if not owner.player: return
	
	var direction : Vector2 = (owner.player.global_position - parent.global_position).normalized()
	
	parent.motion = direction * parent.MAXSPEED

func process_state():

	if $Timer.is_stopped():
		return "ATTACK"
	if not owner.player:
		return "IDLE"


