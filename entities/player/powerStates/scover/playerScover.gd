extends PlayerBase

onready var animation := $AnimationTree
onready var playback : AnimationNodeStateMachinePlayback= animation["parameters/playback"] 
onready var raycastShape := $raycast
onready var collider := $sprite/collide

onready var insideDigable := []
onready var canDig := false
onready var isDigging := false
const detectDig := [
	Vector2(-12, -8), Vector2(-8, -8), Vector2(-4, -8), Vector2(0, -8),Vector2(4, -8), Vector2(8, -8), Vector2(12, -8),
	Vector2(-12, 0), Vector2(-8, 0), Vector2(-4, 0),Vector2(0, 0), Vector2(4, 0), Vector2(8, 0), Vector2(12, 0),
	Vector2(-12, 8), Vector2(-8, 8), Vector2(-4, 8),Vector2(0, 8),Vector2(4, 8), Vector2(8, 8), Vector2(12, 8),
	Vector2(-12, 16), Vector2(-8, 16), Vector2(-4, 16),Vector2(0, 16),Vector2(4, 16), Vector2(8, 16), Vector2(12, 16),
	Vector2(-12, 24), Vector2(-8, 24), Vector2(-4, 24),Vector2(0, 24),Vector2(4, 24), Vector2(8, 24), Vector2(12, 24)
]

var driveVelocity := 500
var diggingVelocity := 200

func _physics_process(delta):
	physics_process(delta)
	_coyoteTimer()
	digBlocks()
	
	if motion.x: $sprite/sprite.flip_h = motion.x < 0  
	
	if active: move()

func digBlocks():
	for detect in detectDig:
		var rotatedPosition : Vector2 = detect.rotated(rotation)
		
		for map in insideDigable:
			if not is_instance_valid(map):
				insideDigable.erase(map)
				continue
			var cell : Vector2 = map.world_to_map(rotatedPosition + map.to_local(global_position))
			
			canDig = map.get_cellv(cell) in [17, 18]
			if map.get_cellv(cell) != 17 or not isDigging: continue
			
			var atlasPos : Vector2 = map.get_cell_autotile_coord(cell.x, cell.y)
			map.set_cellv(cell, 18, false, false, false, atlasPos)

func _on_inside_body_entered(body):
	if body.is_in_group("digable") and body is TileMap:
		insideDigable.append(body)

func _on_inside_body_exited(body):
	if body.is_in_group("digable") and body.get_parent() is TileMap:
		if insideDigable.has(body.get_parent()):
			insideDigable.erase(body)


