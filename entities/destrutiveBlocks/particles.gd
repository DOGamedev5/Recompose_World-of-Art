extends Node2D

onready var part1 = $CPUParticles2D
onready var part2 = $CPUParticles2D2

export var resistence := 1

func _ready():
	
	
	part1.texture["region"].position.x = min(16 * resistence - 16, 16)
	part2.texture["region"].position.x = min(16 * resistence - 16, 16)
	
	part1.emitting = true
	part2.emitting = true
	

func _on_Timer_timeout():
	queue_free()
