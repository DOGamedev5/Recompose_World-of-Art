class_name CutScene extends AnimationPlayer

export(Array, Texture) var images
export var saveGameAfter := false
var dialogs
var waitingDialog := false

func setup(Dialogs):
	dialogs = Dialogs

func _start():
	Global.playerHud.dialog.connect("dialogClosed", self, "_dialogStopped")
	Global.player.setCinematic(true)

func _end():
	Global.player.setCinematic(false)
	if saveGameAfter:
		FileSystemHandler.saveGameData()

func _setDialog(index := 0):
	if not Global.playerHud.dialog.opened:
		Global.playerHud.dialog.open(dialogs[index], images)
	
	if is_playing():
		stop(false)
		waitingDialog = true
		

func _dialogStopped():
	if waitingDialog:
		play()
		waitingDialog = false
	

func setInput(action : String, state := 1.0):
	Global.setInput(action, state)

func _tradePlayerVisibility(objectPath : NodePath):
	var object := get_node("../" + objectPath)
	object.visible = Global.player.visible
	Global.player.visible = not object.visible

func _trade(object):
	object.visible = Global.player.visible
	Global.player.visible = not object.visible
	

