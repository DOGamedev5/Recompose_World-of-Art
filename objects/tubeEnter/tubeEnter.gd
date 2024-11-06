extends PathBase

export(int, "left", "right", "up", "down") var direction := 1 setget setDirection

onready var camera := $Camera2D

var enteredArea := false

func _ready():
	warpType = "tube"
	
	var currentRoom = Global.world.currentRoom
	
	camera.limit_left = currentRoom.limitsMin.x
	camera.limit_top = currentRoom.limitsMin.y
	camera.limit_right = currentRoom.limitsMax.x
	camera.limit_bottom = currentRoom.limitsMax.y
	setDirection(direction)
	
	var textureName = Global.currentRoom.world.get_file()
	$sprite.texture = load("res://objects/tubeEnter/sprites/%s.pxo" % (textureName))

func _physics_process(_delta):
	if enteredArea and detectEnter() and not $AnimationPlayer.is_playing():
		Global.player.pause_mode = Node.PAUSE_MODE_STOP
		Global.player.active = false
		Global.player.motion = Vector2.ZERO
		Global.player.visible = false
		$Camera2D.current = true
		$AnimationPlayer.play("enter")
		yield($AnimationPlayer, "animation_finished")
		changeRoom()

func detectEnter():
	match direction:
		0: if Global.player.motion.x > 0: return true
		1: if Global.player.motion.x < 0: return true
		2: if Global.player.motion.y > 0: return true
		3: if Global.player.motion.y < 0: return true
		
	return false
	

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


func init():
	var directions := [Vector2.LEFT, Vector2.RIGHT, Vector2.UP, Vector2.DOWN]
	
	Global.player.moving = false
	$Camera2D.current = true
	
	Global.player.global_position = (global_position + directions[direction] * 86) + Vector2.DOWN*32
	
	$AnimationPlayer.play("enter")
	yield($AnimationPlayer, "animation_finished")
	
	Global.player.visible = true
	Global.player.camera.current = true
	Global.player.moving = true
	Global.player.active = true
	


func _on_Node2D_area_entered(area):
	var object = area.get_parent()
	
	if object is PlayerBase:
		enteredArea = true

func _on_tube_area_exited(area):
	var object = area.get_parent()
	
	if object is PlayerBase:
		enteredArea = false
