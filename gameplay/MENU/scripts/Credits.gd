extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var tween := $Tween

var current := false

func _on_buttonMenu_pressed():
	parent.transition(initial, [self, options, saves])

func enter():
	modulate = Color.transparent
	$MarginContainer.margin_top = 0
	parent.current = self
	modulate = Color.transparent
	$MarginContainer.margin_top = 0
	tween.interpolate_property(self, "modulate", Color.transparent, Color.white, 2, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.5)
	tween.interpolate_property($MarginContainer, "margin_top", 0, -3072, 140, Tween.TRANS_LINEAR, Tween.EASE_IN, 1.7)
	tween.start()
