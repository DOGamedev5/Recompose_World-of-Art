extends State

export var activaded := false

func enter(_lastState):
	$"../../AnimationPlayer".play("IDLE")

## process_state its called in _physics_process
func process_state():
	if activaded:
		return "TOJUMP"
	
	return null
	

