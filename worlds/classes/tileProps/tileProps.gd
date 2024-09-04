tool
class_name TileProps extends TileMap

export var setup = false setget _set_setup

func _init():
	scale = Vector2(2, 2)
	cell_size = Vector2(8, 8)
	set_tileset(load("res://worlds/classes/tileProps/tileProps.tres"))

func _getProps():
	var parents := {}
	var parentsKeys := [
		"blocks",
		"stairs",
		"coins"
	]
	
	var props = [
		load("res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn"),
		load("res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn"),
		load("res://objects/ladder/ladder.tscn"),
		load("res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn"),
		load("res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn"),
		load("res://objects/keyBlock/block/blockKey.tscn"),
		load("res://objects/keyBlock/key/keyCollect.tscn"),
		load("res://objects/coins/coin.tscn")
	]
	
	
	for n in parentsKeys:
		parents[n] = get_node_or_null("../" + n)
		print("a")
		if parents[n]: continue
		
		parents[n] = Node2D.new()
		parents[n].name = n
		get_parent().add_child(parents[n])
		parents[n].set_owner(get_parent())
		print("b")
	
	for i in range(props.size()):
		for cell in get_used_cells_by_id(i):
			var newProp = props[i].instance()
			set_cellv(cell, -1)
			
			newProp.position = cell*16
			
			if i in [1, 4]:
				newProp.resistence = 2
			
			get_parent().add_child(newProp)
			newProp.set_owner(get_parent())
#			if i in [0, 1, 3, 4]:
#				parents["blocks"].add_child(newProp)
#				newProp.set_owner(parents["blocks"])
#			elif i in [2]:
#				parents["stairs"].add_child(newProp)
#				newProp.set_owner(parents["stairs"])
#			elif i in [7]:
#				parents["coins"].add_child(newProp)
#				newProp.set_owner(parents["coins"])
#			else:
#				get_parent().add_child(newProp)
#				newProp.set_owner(get_parent())

func _set_setup(value):
	setup = value
	_getProps()
	
