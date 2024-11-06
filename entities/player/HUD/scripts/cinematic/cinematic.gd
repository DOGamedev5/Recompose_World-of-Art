extends CanvasLayer

onready var tween = $Tween
onready var up = $up
onready var down = $down

func actived():
	$"../".currentScreen = "CINE"
	visible = true
	$"../HUD".visible = false
	
	
	tween.interpolate_property(up, "rect_size", up["rect_size"], Vector2(up["rect_size"].x, 100), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "rect_size", down["rect_size"], Vector2(down["rect_size"].x, 100), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "margin_top", down["margin_top"], -100, 0.3, Tween.TRANS_CUBIC)
	
	tween.start()

func desactivaded():
	$"../".currentScreen = "HUD"
	
	$"../HUD".visible = true
	
	tween.interpolate_property(up, "rect_size", up["rect_size"], Vector2(up["rect_size"].x, 0), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "rect_size", down["rect_size"], Vector2(down["rect_size"].x, 0), 0.3, Tween.TRANS_CUBIC)
	tween.interpolate_property(down, "margin_top", down["margin_top"], 0, 0.3, Tween.TRANS_CUBIC)
	
	tween.start()
	
	yield(tween, "tween_all_completed")
	visible = false
