tool
class_name TileProps extends TileMap

export var setup = false setget _set_setup

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
	
	for i in range(props.size()):
		for cell in get_used_cells_by_id(i):
			var newProp = props[i].instance()
			set_cellv(cell, -1)
			
			newProp.position = cell*16
			if i in [1, 4]:
				newProp.resistence = 2
			
			get_parent().add_child(newProp)
			newProp.set_owner(get_parent())

func _set_setup(value):
	setup = value
	_getProps()
	
