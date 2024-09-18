extends CanvasLayer

onready var tween = $Tween

func _ready():
	AudioManager.playMusic("recompose")
	Global.roomsToSave.clear()
	Global.dimensionsRooms.clear()
	$initial/VBoxContainer/start.grab_focus()

func transition(show, hide : Array):
	tween.interpolate_property(show, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.4,
		Tween.TRANS_CUBIC, Tween.EASE_OUT, 0.5)
	show.current = true
	
	for obj in hide:
		obj.current = false
		obj.changed()
		tween.interpolate_property(obj, "rect_scale", obj["rect_scale"], Vector2(0, 0), 0.4,
		Tween.TRANS_CUBIC, Tween.EASE_IN)
	
	tween.start()
	yield(tween, "tween_all_completed")
	
	show.enter()
