extends Area2D

onready var sprite := $WorldSelect
onready var tween := $Tween
onready var CaveWorldButton := $CanvasLayer/margin/panel/list/caveWorld

onready var worlds := ["res://worlds/paintWorld/world.tscn"]
enum {
	CaveWorld
}
var selectedWorld : int = 0

func _ready():
	CaveWorldButton.connect("pressed", self, "selected", [CaveWorld])
	$CanvasLayer.modulate = Color.transparent
	$CanvasLayer.visible = false
	$CanvasLayer/margin/close.disabled = true

func _exit(world := selectedWorld):
	if Network.is_host():
		Network.sendP2PPacket(-1, {"type" : "selectedWorld", "world" : selectedWorld}, 2)
	
	tween.interpolate_property($CanvasLayer/ColorRect, "modulate", Color(1, 1, 1, 0), Color.white, 0.6, Tween.TRANS_CUBIC)
	tween.start()
	$CanvasLayer/ColorRect.visible = true
	get_tree().root.set_disable_input(true)

func selected(id):
	$CanvasLayer/margin/close.disabled = true
	_exit()
	selectedWorld = id

func _exit_tree():
	get_tree().root.set_disable_input(false)

func _on_Tween_tween_completed(object, key):
	if object == $CanvasLayer:
		$CanvasLayer.visible = false

	elif object == $CanvasLayer/ColorRect:
		LoadSystem.openScreen()
		worldSelect(selectedWorld)

func worldSelect(world):
	LoadSystem.addToQueueChangeScene(worlds[world])

func _on_interactBallon_entered():
	sprite.frame = 1

func _on_interactBallon_exitered():
	sprite.frame = 0

func _on_interactBallon_interacted():
	if $CanvasLayer.visible: return
	$CanvasLayer/margin/close.disabled = false
	
	$CanvasLayer.visible = true
	tween.interpolate_property($CanvasLayer, "modulate", $CanvasLayer.modulate, Color.white, 0.3, Tween.TRANS_QUAD, Tween.EASE_IN)
	
func _on_close_pressed():
	if not $CanvasLayer.visible: return
	$CanvasLayer/margin/close.disabled = true
	
	tween.interpolate_property($CanvasLayer, "modulate", $CanvasLayer.modulate, Color.transparent, 0.3, Tween.TRANS_QUAD, Tween.EASE_OUT)
	$CanvasLayer.visible = false
