extends LevelClass

func _ready():
	if Global.changingInfo.warpType == "warp" and Global.changingInfo.warpID == 0:
		$room1.play()
		canvasModulate.color = Color(0, 0, 0.01)
		currentColor = canvasModulateColor
