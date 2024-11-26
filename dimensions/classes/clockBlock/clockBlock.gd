extends StaticBody2D

export var solid := true

func _physics_process(delta):
	set_collision_layer_bit(0, solid and not Global.world.clock)
	
	$ClockBlock.frame = 1 - int(get_collision_layer_bit(0))
	if $ClockBlock.frame == 1:
		modulate.a = 0.6
	else:
		modulate.a = 1
