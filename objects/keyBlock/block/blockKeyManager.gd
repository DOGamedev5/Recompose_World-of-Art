extends Node2D

export(NodePath) var keysManager

func _ready():
	var _1 =  get_node(keysManager).connect("keysCollected", self, "destroyBlocks")

func destroyBlocks():
	for block in get_children():
		block.destroy()
