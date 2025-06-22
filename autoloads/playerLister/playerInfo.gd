extends Node
class_name PlayerInfo

export var playerName := "New Player" setget playerNameSet
puppet var playerNamePuppet := playerName setget playerNamePuppetSet
export var character := "lodrofo"

func _ready():
	var timer = Timer.new()
	timer.wait_time = 0.05
	timer.connect("timeout", self, "networkUpdate")
	add_child(timer)
	timer.start()
	timer.set_network_master(get_network_master())

func playerNamePuppetSet(value):
	playerNamePuppet = value
	playerName = value

func playerNameSet(value):
	playerName = value
	
func networkUpdate():
	if is_network_master():
		rset_unreliable("playerNamePuppet", playerName)

	
