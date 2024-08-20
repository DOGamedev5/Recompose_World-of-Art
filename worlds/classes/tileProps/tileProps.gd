tool
class_name TileProps extends TileMap

export var setup = false setget _set_setup

onready var blocksParent
onready var stairsParent

func _init():
	scale = Vector2(2, 2)
	cell_size = Vector2(8, 8)
	set_tileset(load("res://worlds/classes/tileProps/tileProps.tres"))

func _getProps():
	var props = [
		load("res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn"),
		load("res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn"),
		load("res://objects/ladder/ladder.tscn"),
		load("res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn"),
		load("res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn"),
	]
	
	
	
	if get_parent().blocksPath:
		blocksParent = get_node(get_parent().blocksPath)
	else:
		blocksParent = get_node_or_null("../blocks")
		if not blocksParent:
			blocksParent = Node2D.new()
			blocksParent.name = "blocks"
			get_parent().add_child(blocksParent)
			blocksParent.set_owner(get_parent())
			get_parent().blocksPath = blocksParent.get_path()
	
	stairsParent = get_node_or_null("../stairs")
	if not stairsParent:
		stairsParent = Node2D.new()
		stairsParent.name = "stairs"
		get_parent().add_child(stairsParent)
		stairsParent.set_owner(get_parent())
	
	for i in range(props.size()):
		for cell in get_used_cells_by_id(i):
			var newProp = props[i].instance()
			set_cellv(cell, -1)
			
			newProp.position = cell*16
			
			if i in [1, 4]:
				newProp.resistence = 2
				
			if i in [0, 1, 3, 4]:
				blocksParent.add_child(newProp)
				blocksParent.set_owner(get_parent())
			else:
				stairsParent.add_child(newProp)
				stairsParent.set_owner(get_parent())

func _set_setup(value):
	setup = value
	_getProps()
	
