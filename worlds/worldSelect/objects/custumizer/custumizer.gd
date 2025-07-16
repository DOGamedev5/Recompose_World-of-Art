extends Area2D

onready var sprite := $Custumizer
onready var playerExample := $CanvasLayer/Control/margin/hbox/background/sprite
onready var pallete := $CanvasLayer/Control/margin/hbox/options/Pallete
onready var hud := $CanvasLayer
onready var hudControl := $CanvasLayer/Control
onready var tween := $Tween
onready var close := $CanvasLayer/Control/margin/hbox/close

func _ready():
	hud.hide()
	for color in pallete.get_children():
		color.connect("selected", self, "selected")
		if color.hueShift == 0:
			color.toggled = true

func selected(hueValue):
	playerExample.material["shader_param/hue_shift"] = hueValue

func _on_interactBallon_entered():
	sprite.frame = 1

func _on_interactBallon_exitered():
	sprite.frame = 0

func _on_interactBallon_interacted():
	if hud.visible: return
	close.disabled = false
	Global.player.moving = false
	Global.player.motion = Vector2.ZERO
	
	hud.visible = true
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.white, 0.2, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()

func _on_close_pressed():
	if not hud.visible: return
	close.disabled = true
	Global.player.moving = true
	
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.transparent, 0.2, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()

func _on_Tween_tween_completed(object, _key):
	if object == hudControl and object.modulate == Color.transparent:
		hud.visible = false
