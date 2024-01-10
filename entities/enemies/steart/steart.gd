extends EnemyBase

func _physics_process(_delta):
	$Sprite.flip_h = fliped
	var input := .0
	if player:
		input = sign(player.position.x - position.x)
		
	motion.x = moveBase(input, motion.x)
	
	motion = move_and_slide(motion)

func _damaged(damage, area):
	if damage > 0:
		queue_free()
