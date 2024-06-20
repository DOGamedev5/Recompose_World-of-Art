extends CanvasLayer

onready var tween = $Tween
onready var colorRect = $ColorRect
onready var timer = $Timer

signal transitionedIn

func transitionIn():
	Global.player.active = false
	visible = true
	timer.start()
	tween.interpolate_property(
		colorRect,
		"self_modulate",
		colorRect["self_modulate"],
		Color.white,
		0.1,
		Tween.TRANS_CUBIC,
		Tween.EASE_IN
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	emit_signal("transitionedIn")


func transitionOut():
	
	if not timer.is_stopped():
		yield(timer, "timeout")
	
	tween.interpolate_property(
		colorRect,
		"self_modulate",
		colorRect["self_modulate"],
		Color(0, 0, 0, 0),
		0.1,
		Tween.TRANS_CUBIC,
		Tween.EASE_OUT
	)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	Global.player.active = true
	visible = false
