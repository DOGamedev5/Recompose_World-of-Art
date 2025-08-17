extends State

var delay := false

func enter(_ls):
	delay = false
	parent.motion = Vector2.ZERO
	parent.animationPlayback.travel("IDLE")

func process_state():
	if $Timer.is_stopped() and delay:
		return "SEEK"

func process_physics(_delta):
	if parent.player and $Timer.is_stopped() and not delay:
		$Timer.start()
		delay = true
	elif not parent.player:
		delay = false
