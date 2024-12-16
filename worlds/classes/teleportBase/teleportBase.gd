class_name TeleportBase extends Area2D

export(NodePath) var destinationPath
onready var destination := get_node_or_null(destinationPath)

var warpType := "warp"


func teleport():
	if not destination: return
	destination.init()
	print("B")

func init():
	Global.player.global_position = global_position

func _ready():
	collision_layer = 1024
	collision_mask = 0
