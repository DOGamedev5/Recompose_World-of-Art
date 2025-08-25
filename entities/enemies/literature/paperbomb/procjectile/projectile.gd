extends AttackComponent

var velocity := 800

func _ready():
	$Tween.interpolate_property(self, "velocity", velocity, 0, 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.interpolate_property($sprite, "modulate", Color.white, Color(0.16, 0.01, 0.01), 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.start()

func _physics_process(delta):
	global_position += Vector2(cos(rotation), sin(rotation)) * velocity * delta
	
	if velocity == 0:
		kill()

func _on_Area2D_body_entered(body):
	if body is TileMap or body is StaticBody2D:
		kill()

func _on_Timer_timeout():
	queue_free()

func kill():
	$sprite.visible = false
	damage = 0
	velocity = 0
	$CPUParticles2D.emitting = false
	$Timer.start()
