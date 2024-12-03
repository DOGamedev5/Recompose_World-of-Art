extends CanvasLayer

onready var tween = $Tween
onready var transitionPlayer := $transition/AnimationPlayer
onready var backgroundPlayer := $background/AnimationPlayer
onready var current := $initial

func _ready():
	AudioManager.playMusic("recompose")

func transition(show, hide : Array):
	show.current = true
	transitionPlayer.play(show.name)
	yield($transition, "transitionTrigger")
	show.visible = true
	
	for obj in hide:
		obj.current = false
		obj.changed()
		obj.visible = false
	
	backgroundPlayer.play(show.name)
	
	show.enter()
