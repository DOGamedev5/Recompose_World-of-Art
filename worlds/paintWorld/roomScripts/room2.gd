extends RoomClass

var dialogs := [
	[
		TextDialog.new("Hey? there is a monument here."),
	],
	[
		TextDialog.new("Hm, this says... \"IN MEMORY OF THE LITERATURY KINGDOM.\".\nLiteratury Kingdom? Hey? what's this?!")
	]
]


func _ready():
	$CutScene.setup(dialogs)

func play():
	$CutScene._start()
	$CutScene.play("enter")



func _on_CutScene_animation_finished(_anim_name):
	Global.playerHud.transition.transitionIn()
