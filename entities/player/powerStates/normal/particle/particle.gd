extends CPUParticles2D

var currentSprite : Sprite

func _ready():
	texture = currentSprite.texture
	material["particles_anim_h_frames"] = currentSprite.hframes
	scale.x = 1 - (int(currentSprite.flip_h)*2)
	emitting = true


func _on_Timer_timeout():
	queue_free()
