tool
class_name TilepropsScene extends TileMap

onready var parents := {}
export var setup = false setget _set_setup

func _init():
	scale = Vector2(2, 2)
	cell_size = Vector2(8, 8)
	set_tileset(load("res://worlds/classes/tileProps/tileProps.tres"))

func _getpropsScene():
	if not is_inside_tree():
		queue_free()
		return
	
	var parentsKeys := [
		"blocks",
		"stairs",
		"coins",
		"BreakableTilesManager"
	]
	
	var propsScene := [
		"res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn",
		"res://objects/destrutiveBlocks/normal/32x32/destrutiveBlock.tscn",
		"res://objects/ladder/ladder.tscn",
		"res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn",
		"res://objects/destrutiveBlocks/normal/16x16/destrutiveBlock.tscn",
		"res://objects/keyBlock/block/blockKey.tscn",
		"res://objects/keyBlock/key/keyCollect.tscn",
		"res://objects/coins/coin.tscn",
		BreakableTiles
	]
	
	var parent = get_tree().edited_scene_root
	
	if not parent: return

	for n in parentsKeys:
		
		parents[n] = parent.get_node_or_null(n)
		if parents[n]: continue
		
		if not n == "BreakableTilesManager":
			parents[n] = Node2D.new()
		else:
			parents[n] = BreakableTilesManager.new()
		
		parents[n].name = n
		parent.add_child(parents[n])
		parents[n].set_owner(get_parent())
	
	for i in range(propsScene.size()):
		var obj : PackedScene
		if propsScene[i] is String:
			obj = load(propsScene[i])
		else:
			obj = PackedScene.new()
			obj.pack(propsScene[i].new())
			
		setProp(i, obj)

func setProp(i, obj):
	
	var parent := get_tree().edited_scene_root
	for cell in get_used_cells_by_id(i):
		var newProp
		
		newProp = obj.instance(PackedScene.GEN_EDIT_STATE_MAIN_INHERITED)
		
		set_cellv(cell, -1)
		
		newProp.position = cell*16
		
		if i in [1, 4]:
			newProp.resistence = 2
		
		if i in [0, 1, 3, 4]:
			parents["blocks"].add_child(newProp)
			
		elif i in [2]:
			parents["stairs"].add_child(newProp)
			
		elif i in [7]:
			parents["coins"].add_child(newProp)
		
		elif i in [8]:
			parents["BreakableTilesManager"].add_child(newProp)
		else:
			parent.add_child(newProp)
		
		newProp.set_owner(get_parent())

func _set_setup(value):
	setup = value
	_getpropsScene()
	
