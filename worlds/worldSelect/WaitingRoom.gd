extends LevelClass

func _ready():
	Network.sendP2PPacket(-1, {"type" : "startGame"}, 2)
	Network.connect("worldSelected", self, "selected")
