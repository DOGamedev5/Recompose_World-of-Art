class_name CutScene extends AnimationPlayer

export var dialogPath : NodePath
var dialog

var dialogs

var onDialog : bool

func _setup(Dialogs):
	if dialogPath:
		dialog = get_node(dialogPath)
		
	dialogs = Dialogs

func _start():
	Global.player.setCinematic(true)

func _setDialog(index := 0):
	if not dialog.hasInteracted:
		dialog.setup(dialogs[index])
		dialog.interacted()
		onDialog = true
	
func _input(_event):
	if onDialog:
		if Input.is_action_just_pressed("interact"):
			dialog.interacted()
			if not dialog.hasInteracted:
				onDialog = false

