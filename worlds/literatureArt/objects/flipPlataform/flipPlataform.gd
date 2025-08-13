extends StaticBody2D

onready var stateMachine := $StateMachine

func _on_Area2D_area_entered(area):
	if not area.get_parent().is_in_group("book"): return
	
	
