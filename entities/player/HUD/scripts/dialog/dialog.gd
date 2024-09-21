extends CanvasLayer

onready var backgroung := $background
onready var rect := $Control/MarginContainer/NinePatchRect
onready var speakerOmage := $Control/MarginContainer/NinePatchRect/HBoxContainer/image
onready var speakerName := $Control/MarginContainer/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/name
onready var speakerText := $Control/MarginContainer/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/RichTextLabel
onready var speakerOptions := $Control/MarginContainer/NinePatchRect/HBoxContainer/MarginContainer/VBoxContainer/options

onready var tween := $Tween

enum DialogType {
	NORMAL
	QUESTION
	NAME_NORMAL
	NAME_QUESTION
	IMAGE_NORMAL
	IMAGE_QUESTION
	IMAGE_NAME_NORMAL
	IMAGE_NAME_QUESTION
}

signal optionChosen(question, option)
signal dialogClosed
signal dialogOpened

var hasInteracted := false
var optionID := 0
var currentType : int = DialogType.NORMAL
var dialogQueue := []

func open(dialogs : Array, images : Array):
	emit_signal("dialogOpened")
	tween.interpolate_property(rect, "rect_scale", rect["rect_scale"],
	Vector2(1, 1), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.interpolate_property(backgroung, "self_modulate", backgroung["self_modulate"],
	Color.white, 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func exit():
	emit_signal("dialogClosed")
	tween.interpolate_property(rect, "rect_scale", rect["rect_scale"],
	Vector2(0, 0), 0.4, Tween.TRANS_CIRC, Tween.EASE_IN_OUT)
	tween.interpolate_property(backgroung, "self_modulate", backgroung["self_modulate"],
	Color(0,0,0,0), 0.3, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()
