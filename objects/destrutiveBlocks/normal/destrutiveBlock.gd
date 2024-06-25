tool
class_name Block extends KinematicBody2D

onready var particle = preload("res://objects/destrutiveBlocks/particles.tscn")

export var resistence := 1 setget _resistence_set

func _resistence_set(value):
	var frame = clamp(value -1, 0, 1)
	$"%sprite".frame = frame
	resistence = value
		

func _on_HitboxComponent_HitboxDamaged(damage, _area):
	if damage >= resistence:
		var particleInstance = particle.instance()
		
		particleInstance.resistence = resistence
		get_parent().add_child(particleInstance)
		particleInstance.position = position
		
		
		queue_free()
