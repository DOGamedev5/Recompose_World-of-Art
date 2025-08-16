extends Area2D

onready var sprite := $WorldSelect
onready var tween := $Tween
onready var CaveWorldButton := $CanvasLayer/Control/margin/panel/list/caveWorld
onready var literatureArtButton := $CanvasLayer/Control/margin/panel/list/literatureWorld
onready var hud := $CanvasLayer
onready var hudControl := $CanvasLayer/Control
onready var close := $CanvasLayer/Control/margin/close
onready var totalText := $CanvasLayer/Control/margin/panel/ready/Label

export var already := 0
export var selectedWorld := false

enum {
	literatureArt
	CaveWorld
}

func _ready():
	literatureArtButton.connect("pressed", self, "selected", [literatureArt])
	CaveWorldButton.connect("pressed", self, "selected", [CaveWorld])
	hudControl.modulate = Color.transparent
	hud.visible = false
	close.disabled = true
	

func _process(_delta):
	if Network.lobbyMembers.size() > 1:
		totalText.text = tr("_ready_waiting") % [already, Network.lobbyMembers.size() - 1]

func _input(event):
	if event.is_action_pressed("menu") and hud.visible:
		_on_close_pressed()

func selected(id):
	close.disabled = true
	get_parent().selectedWorld = id
	selectedWorld = true
	if  Network.lobbyMembers.size() > 1:
		$CanvasLayer/Control/margin/panel/ready.visible = true
	else:
		Global.player.moving = true
		get_parent().exit(id)

func _on_stop_pressed():
	close.disabled = false
	get_parent().selectedWorld = -1
	selectedWorld = false
	$CanvasLayer/Control/margin/panel/ready.visible = false

func _on_interactBallon_entered():
	sprite.frame = 1

func _on_interactBallon_exitered():
	sprite.frame = 0

func _on_Tween_tween_completed(object, _key):
	if object == hudControl and object.modulate == Color.transparent:
		hud.visible = false

func _on_interactBallon_interacted():
	if hud.visible or not Network.is_host(): return
	close.disabled = false
	Global.player.moving = false
	Global.player.motion = Vector2.ZERO
	
	hud.visible = true
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.white, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	tween.start()
	yield(tween, "tween_completed")
	literatureArtButton.grab_focus()
	
func _on_close_pressed():
	if not hud.visible: return
	close.disabled = true
	Global.player.moving = true
	
	tween.interpolate_property(hudControl, "modulate", hudControl.modulate, Color.transparent, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	literatureArtButton.release_focus()
