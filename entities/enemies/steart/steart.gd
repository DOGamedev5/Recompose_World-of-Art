extends EnemyBase

func _physics_process(_delta):
	$Sprite.flip_h = fliped
	var input := Vector2.ZERO
	if player:
		input.x = sign(player.position.x - position.x)
		
	motion = moveBase(input, motion)
#	else:
#		motion = Vector2.ZERO
	
	motion = move_and_slide(motion)

func _damaged(damage):
	if damage > 0:
		queue_free()
