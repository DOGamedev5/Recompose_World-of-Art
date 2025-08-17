extends NPCBase

func _on_AnimationPlayer_animation_finished(_anim_name):
	$Timer.wait_time = rand_range(0.0, 1.9)
	$Timer.start()

func _on_Timer_timeout():
	$AnimationPlayer.play("IDLE")
