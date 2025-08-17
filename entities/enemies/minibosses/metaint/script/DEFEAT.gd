extends State

onready var interactArea = $"../../interact"
onready var dialogRect = $"../../dialog"

const dialog = [
	{"image" : 0, "react" : 0, "text" : "metaint_3", "name" : "metaint"},
	{"image" : 0, "react" : 0, "text" : "metaint_4", "name" : "metaint"},
	{"image" : 0, "react" : 0, "text" : "metaint_5", "name" : "metaint"}
]

func enter(_lastState):
	$"../../interactBallon".visible = true
	parent.motion.x = 0
	parent.playback.travel("DEFEAT")
	interactArea.monitoring = true
	dialogRect.addDialog(dialog)

