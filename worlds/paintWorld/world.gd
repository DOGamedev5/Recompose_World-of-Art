extends LevelClass

func _ready():
	if Global.changingInfo.warpType == "warp" and Global.changingInfo.warpID == 0:
		yield($EnablePlaceholder, "screen_entered")
		$EnablePlaceholder.obj.play()
		canvasModulate.color = Color(0, 0, 0.01)
		currentColor = canvasModulateColor
