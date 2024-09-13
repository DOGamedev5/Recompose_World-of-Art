extends DimensionPortal

onready var animation = $AnimationPlayer

func _on_interactBallon_entered():
	animation.play("open")

func _on_interactBallon_exitered():
	animation.play_backwards("open")


