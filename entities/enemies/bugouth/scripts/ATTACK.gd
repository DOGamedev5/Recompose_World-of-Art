extends State

var direction : Vector2

func enter(_ls):
	parent.animationPlayback.travel("DASH")
	$"../../AttackComponent".setDamage(10)
	$Timer.start()
	direction = (Global.player.global_position - parent.global_position).normalized()
	

func process_physics(_delta):
	$"../../Bugouth".rotation = direction.angle() + (PI * int(parent.fliped))
	parent.motion = direction * 800

func process_state():

	if $Timer.is_stopped():
		return "IDLE"

func exit():
	$"../../Bugouth".rotation = 0
	$"../../AttackComponent".setDamage(0)
