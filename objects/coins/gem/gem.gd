extends Area2D

var time := 0.0

func _ready():
	var _1 = connect("area_entered", self, "_on_coin_area_entered")
	randomize()
	var typeCoin = randi() % 3
	$gem.region_rect.position.y = typeCoin * 8

func _process(delta):
	$gem.position.y = cos(time)*20
	time += delta
	
	if time > PI*2:
		time -= PI*2

func _on_coin_area_entered(area):
	if not area.is_in_group("player"): return
	if not Network.is_owned(area.get_parent().OwnerID): return
	
	Global.playerHud.addPoints(200)
	
	$CPUParticles2D.emitting = true
	$gem.modulate.a = 0.3
	collision_layer = 0
	collision_mask = 0
	set_process(false)
	set_physics_process(false)
