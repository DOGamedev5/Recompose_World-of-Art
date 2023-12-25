tool
extends KinematicBody2D

export var resistence := 1 setget _resistence_set


func _resistence_set(value):
	var frame = clamp(value -1, 0, 1)
	$"%sprite".frame = frame
	resistence = value
		

func _on_HitboxComponent_HitboxDamaged(damage):
	if damage >= resistence:
		queue_free()


func _on_block_script_changed():
	resistence = resistence
