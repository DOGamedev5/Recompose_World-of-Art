extends NPCBase

var dialogs := [
	[
		TextDialog.new("atrscta_1-0", "atrscta"),
		TextDialog.new("atrscta_1-1", "atrscta"),
		TextDialog.new("atrscta_1-2", "atrscta"),
		TextDialog.new("atrscta_1-3", "atrscta")
	]
]

func _physics_process(_delta):
	if entered:
		if Input.is_action_just_pressed("interact") and not Global.playerHud.dialog.opened:
			Global.playerHud.dialog.open(dialogs[0])
