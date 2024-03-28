extends State

onready var interactArea = $"../../interact"
onready var dialogRect = $"../../dialog"

const dialog = [
	"Oh... you are pretty strong little one... what's your name?\nLodrofo...? hum, cool name",
	"Now you are part of the guard of the paint kingdom, and you will be called Sir Lodrofo!"
]

func enter(_lastState):
	parent.motion.x = 0
	parent.playback.travel("DEFEAT")
	interactArea.monitoring = true
	dialogRect.addDialog(dialog)

