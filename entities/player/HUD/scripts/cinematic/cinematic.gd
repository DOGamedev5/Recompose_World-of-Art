extends CanvasLayer

onready var tween = $Tween
onready var up = $up
onready var down = $down
onready var parent := get_parent()

func actived():
	parent.currentScreen = "CINE"
	visible = true
	parent.HUD.visible = false
	Global.player.set_process_input(false)
	tween.interpolate_property(up, "rect_size", up["rect_size"], Vector2(up["rect_size"].x, 100), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "margin_top", down["margin_top"], -100, 0.3, Tween.TRANS_CUBIC)
	
	tween.start()

func desactivaded():
	parent.currentScreen = "HUD"
	
	Global.inputEnabled = true
	parent.HUD.visible = true
	
	tween.interpolate_property(up, "rect_size", up["rect_size"], Vector2(up["rect_size"].x, 0), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "margin_top", down["margin_top"], 0, 0.3, Tween.TRANS_CUBIC)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	visible = false
	Global.player.set_process_input(true)
