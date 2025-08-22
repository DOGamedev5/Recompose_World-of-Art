extends CPUParticles2D

var spriteTexture
var hframes : int
var fliped := false

func _ready():
	texture = spriteTexture
	material["particles_anim_h_frames"] = hframes
	scale.x = 1 - (int(fliped)*2)
	emitting = true

func _on_Timer_timeout():
	queue_free()
