extends CanvasLayer

export(Array, Resource) var texts

export(NodePath) var interactBallonPath
var interactBallon

export(Array, Texture) var images

func _ready():
	if interactBallonPath:
		interactBallon = get_node(interactBallonPath)
		var _1 = interactBallon.connect("interacted", self, "interacted")

func setup(Texts : Array = texts):
	texts = Texts

func addText(text : String):
	Global.playerHud.dialog.dialogQueue.append(text)

func addDialog(dialog : Array):
	Global.playerHud.dialog.dialogQueue.append_array(dialog)
	
func interacted():
	if not Global.playerHud.dialog.opened:
		Global.playerHud.dialog.open(texts, images)
