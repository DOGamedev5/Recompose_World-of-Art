extends TeleportBase

export(int, 0, 1) var frame := 0 setget doorFrame

func doorFrame(value):
	frame = value
	$CaveDoor.frame = value

func _on_interactBallon_interacted():
	teleport()
