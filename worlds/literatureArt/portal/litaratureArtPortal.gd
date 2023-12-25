extends Node2D

onready var animation = $AnimationPlayer

func _on_Area2D_body_entered(body):
	if body.is_in_group("player"):
		animation.play("open")


func _on_Area2D_body_exited(body):
	if body.is_in_group("player"):
		animation.play_backwards("open")
