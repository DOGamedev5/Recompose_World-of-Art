extends Control

onready var tween = $Tween
onready var colorRect = $ColorRect
onready var stateMachine = $AnimationTree["parameters/playback"]
onready var timeScale = [
	$AnimationTree["parameters/transitionIn/TimeScale/scale"],
	$AnimationTree["parameters/transitionOut/TimeScale/scale"]
]

var lastTransition := ""

func transitionOut(_time := 0.7):
	pass
#	timeScale[1] = 1 / time
#	stateMachine.travel("transitionOut")

func transitionIn(_time := 0.7):
	pass
#	timeScale[0] = 1 / time
#	stateMachine.travel("transitionIn")
