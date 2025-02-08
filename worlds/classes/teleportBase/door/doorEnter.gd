extends TeleportBase

export(int, 0, 1) var frame := 0 setget doorFrame

func doorFrame(value):
	frame = value
	$CaveDoor.frame = value
	
func _ready():
	modulate = Color.white * 1.5 if frame == 1 and Global.options.colorEffect else Color.white

func _on_interactBallon_interacted():
	teleport()
