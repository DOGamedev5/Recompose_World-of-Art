extends PathBase

export(int, "left", "right", "up", "down") var direction := 1 setget setDirection

onready var camera := $Camera2D

func _ready():
	roomData.warpType = "tube"
	var currentRoom = Global.world.currentRoom
	camera.limit_left = currentRoom.limitsMin.x
	camera.limit_top = currentRoom.limitsMin.y
	camera.limit_right = currentRoom.limitsMax.x
	camera.limit_bottom = currentRoom.limitsMax.y
	setDirection(direction)
	var textureName = Global.currentRoom.world.get_file()
	$sprite.texture = load("res://objects/tubeEnter/sprites/%s.pxo" % (textureName))

func setDirection(value):
	var sprite := $sprite
	var rect := $rect
	direction = value
	match direction:
		0:
			sprite.flip_h = true
			sprite.flip_v = false
			sprite.rotation_degrees = 0
			
			rect.position = Vector2(-40, 0)
			
			
		1:
			sprite.flip_h = false
			sprite.flip_v = false			
			sprite.rotation_degrees = 0
			
			rect.position = Vector2(40, 0)
		
			
		2:
			sprite.flip_h = false
			sprite.flip_v = true
			sprite.rotation_degrees = -90
			
			rect.position = Vector2(0, -40)

		3:
			sprite.flip_h = true
			sprite.flip_v = true
			sprite.rotation_degrees = -90
			
			rect.position = Vector2(0, 40)


func init(player):
	var directions := [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	player.pause_mode = Node.PAUSE_MODE_STOP
	$Camera2D.current = true
	$StaticBody2D/CollisionShape2D.disabled = true
	$rect.disabled = true
	
	player.global_position = position + Vector2.DOWN * 48
	
	$AnimationPlayer.play("enter")
	yield($AnimationPlayer, "animation_finished")
	
	player.motion = directions[direction] * 750
	player.visible = true
	player.camera.current = true
	
	yield(get_tree().create_timer(0.5), "timeout")
	
	$StaticBody2D/CollisionShape2D.disabled = false
	$rect.disabled = false
	player.pause_mode = Node.PAUSE_MODE_INHERIT


func _on_Node2D_area_entered(area):
	var object = area.get_parent()
	
	if object is PlayerBase:
		object.pause_mode = Node.PAUSE_MODE_STOP
		object.visible = false
		object.motion = Vector2.ZERO
		object.global_position = position
		$Camera2D.current = true
		$AnimationPlayer.play("enter")
		yield($AnimationPlayer, "animation_finished")
		changeRoom()
		

