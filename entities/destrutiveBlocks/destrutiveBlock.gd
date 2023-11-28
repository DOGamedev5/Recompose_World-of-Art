extends KinematicBody2D


func _on_HitboxComponent_HitboxDamaged(damage):
	if damage >= 1:
		queue_free()
