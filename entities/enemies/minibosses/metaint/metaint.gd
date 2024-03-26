extends EnemyBase

onready var animation = $AnimationTree
onready var playback = animation["parameters/playback"]

export var active := false

func _process(_delta):
	$Metaint.flip_h = fliped
	if active:
		motion = move_and_slide(motion, Vector2.UP)

func changeState(state : String):
	stateMachine.changeState(state)

func _on_metaint_defeated(_enemy):
	queue_free()
