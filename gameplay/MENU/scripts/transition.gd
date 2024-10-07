extends CanvasLayer

signal transitionTrigger

func trigger():
	emit_signal("transitionTrigger")
