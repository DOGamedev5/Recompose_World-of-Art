extends Area2D

onready var sprite := $Custumizer

func _on_interactBallon_entered():
	sprite.visible = true

func _on_interactBallon_exitered():
	sprite.visible = false

func _on_interactBallon_interacted():
	pass # Replace with function body.
