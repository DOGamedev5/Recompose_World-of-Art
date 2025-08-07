extends PlayerBase

onready var animation := $AnimationTree
onready var playback : AnimationNodeStateMachinePlayback= animation["parameters/playback"] 

onready var insideDigable := []
const detectDig := [
	Vector2(-12, -8), Vector2(-8, -8), Vector2(-4, -8), Vector2(0, -8),Vector2(4, -8), Vector2(8, -8), Vector2(12, -8),
	Vector2(-12, 0), Vector2(-8, 0), Vector2(-4, 0),Vector2(0, 0), Vector2(4, 0), Vector2(8, 0), Vector2(12, 0),
	Vector2(-12, 8), Vector2(-8, 8), Vector2(-4, 8),Vector2(0, 8),Vector2(4, 8), Vector2(8, 8), Vector2(12, 8),
	Vector2(-12, 16), Vector2(-8, 16), Vector2(-4, 16),Vector2(0, 16),Vector2(4, 16), Vector2(8, 16), Vector2(12, 16),
	Vector2(-12, 24), Vector2(-8, 24), Vector2(-4, 24),Vector2(0, 24),Vector2(4, 24), Vector2(8, 24), Vector2(12, 24)
]

func _physics_process(_delta):
	digBlocks()
	
func _on_destroy_body_entered(body):
	pass

func digBlocks():
	for detect in detectDig:
		var rotatedPosition : Vector2 = detect.rotated(rotation)
		var positions := ""
		
		for map in insideDigable:
			var cell : Vector2 = map.world_to_map(rotatedPosition + map.to_local(global_position))
			if map.get_cellv(cell) != 17: continue
			
			var atlasPos : Vector2 = map.get_cell_autotile_coord(cell.x, cell.y)
			map.set_cellv(cell, 18, false, false, false, atlasPos)
		

func _on_inside_body_entered(body):
	if body.is_in_group("digable") and body is TileMap:
		insideDigable.append(body)

func _on_inside_body_exited(body):
	if body.is_in_group("digable") and body.get_parent() is TileMap:
		if insideDigable.has(body.get_parent()):
			insideDigable.erase(body)

func _on_inside_area_entered(area):
	pass # Replace with function body.

func _on_inside_area_exited(area):
	pass # Replace with function body.
