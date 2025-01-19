extends RoomClass

onready var playing := false


# Called when the node enters the scene tree for the first time.
func _physics_process(_delta):
	if playing:
		if $elevator.position.y > 320:

			$elevator.motion = 0
			$elevator.actualMotion = 0
			
			var colorA : Color = get_parent().canvasModulate.color
			var colorB : Color = get_parent().currentColor
			
			
			
			if (
				abs(colorA.r - colorB.r) < 0.1 and
				abs(colorA.g - colorB.g) < 0.1 and
				abs(colorA.b - colorB.b) < 0.1
			):
				Global.changeWorld("dimensions", "literatureArt", 0, "portal")
				playing = false

	
func _on_elevator_elevatorInteracted():
	playing = true
	$CutScene.play("elevator")
