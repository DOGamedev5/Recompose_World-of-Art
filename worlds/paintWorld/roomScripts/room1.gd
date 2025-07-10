extends RoomClass

onready var elevator := $elevator
onready var playing := 0


func play():
	playing = 1
	$CutScene._start()
	elevator.position.y = -896
	$CutScene.play("enter")
	elevator.animationTree["parameters/playback"].start("elevator")

func _physics_process(_delta):
	if not playing: return
	
	if elevator.position.y >= -288 and playing == 1:
		elevator.actualMotion = 0
		elevator.motion = 0
		elevator.position.y = -288
		elevator.animationTree["parameters/playback"].travel("RESET")
		playing = 2
		$CutScene.play("walk")
		
	elif not $CutScene.is_playing() and playing == 2:
		playing = 3
		elevator.animationTree["parameters/playback"].travel("broke")
		Global.player.fliped = true
		
	elif (
		elevator.animationTree["parameters/playback"].get_current_node() == "broke" and
		elevator.animationTree["parameters/playback"].get_current_length() <= 
		elevator.animationTree["parameters/playback"].get_current_play_position()
	) and playing == 3:
		playing = 4
		
	elif not $CutScene.is_playing() and playing == 4:
		$CutScene._end()
		playing = 0
	
