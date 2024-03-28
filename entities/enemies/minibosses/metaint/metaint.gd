extends EnemyBase

onready var animation = $AnimationTree
onready var playback = animation["parameters/playback"]

export var active := false

var areas = {
	sword = false,
	jump = false
}

func _process(_delta):
	$Metaint.flip_h = fliped
	if active:
		motion = move_and_slide(motion, Vector2.UP)

func changeState(state : String):
	stateMachine.changeState(state)

func _on_metaint_defeated(_enemy):
	if stateMachine.currentState.name != "DEFEATED":
		stateMachine.changeState("DEFEATED")

func _swordRegion_entered(area):
	if area.is_in_group("player"):
		areas.sword = true

func _swordRegion_exited(area):
	if area.is_in_group("player"):
		areas.sword = false

func _jumpRegion_entered(area):
	if area.is_in_group("player"):
		areas.jump = true

func _jumpRegion_exited(area):
	if area.is_in_group("player"):
		areas.jump = false

	
