class_name PathBase extends Area2D

export(String, "dimensions", "worlds") var worldCatergory := "worlds"
export(String) var worldName = "paintWorld"

export var warpID := 0
var warpType := "warp"

func _ready():
	collision_layer = 1024
	collision_mask = 0
	
func changeRoom():
	get_parent().set_process(false)
	
	Global.changeWorld(worldCatergory, worldName, warpID, warpType)
	
