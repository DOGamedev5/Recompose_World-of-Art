extends CPUParticles2D


func _ready():
	emitting = true
	var _1 = get_tree().create_timer(lifetime).connect("timeout", self, "queue_free")
	

