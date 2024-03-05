extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var tween = $Tween

var current := false

func _process(_delta):
	visible = current

func _on_ExitSaves_pressed():
	current = false
	initial.current = true
	options.current = false

func visibily():
	tween.interpolate_property(self, "rect_scale", Vector2(0, 0), Vector2(1, 1), 0.6,
		Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
#	for obj in $HBoxContainer.get_children():
#		if obj is Panel:
#			obj.visibility_changed()
