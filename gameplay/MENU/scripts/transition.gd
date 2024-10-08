extends CanvasLayer

signal transitionTrigger

func trigger():
	emit_signal("transitionTrigger")

func _on_AnimationPlayer_animation_started(_anim_name):
	get_tree().root.set_disable_input(true)

func transitionFinish():
	get_tree().root.set_disable_input(false)
