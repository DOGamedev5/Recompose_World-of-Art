extends Area2D

var entered := false

func _init():
	collision_layer = 0
	collision_mask = 4096
	
	connect("area_entered", self, "_playerEntered")
	connect("area_exited", self, "_playerExited")

func _process(delta):
	if entered:
		modulate = lerp(modulate, Color(0.4, 0.4, 0.4, 0.5), 10*delta)
	else:
		modulate = lerp(modulate, Color(1, 1, 1, 1), 10*delta)

func _playerEntered(area : Area2D):
	if not area.get_parent().is_in_group("player"): return
	if not Network.is_owned(area.get_parent().OwnerID): return
	
	print(area)
	entered = true
#	modulate = Color(0.4, 0.4, 0.4, 0.4)
	z_index = -1

func _playerExited(area : Area2D):
	if not area.get_parent().is_in_group("player"): return
	if not Network.is_owned(area.get_parent().OwnerID): return
	
	entered = false
#	modulate = Color(1, 1, 1, 1)
	z_index = 1
	
