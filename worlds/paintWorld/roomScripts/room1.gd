extends RoomClass

onready var elevator := $elevator

func play():
	$CutScene._start()
	elevator.position.y = -896
	$CutScene.play("enter")
	elevator.animationTree["parameters/playback"].start("elevator")

func _physics_process(_delta):
	if elevator.position.y >= -288:
		elevator.actualMotion = 0
		elevator.motion = 0
		elevator.position.y = -288
		elevator.animationTree["parameters/playback"].travel("RESET")
