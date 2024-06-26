extends Control

onready var tween = $Tween

export(NodePath) var interactBallonPath : NodePath
var interactBallon : InteractBallon

export(String) var textName

signal interacted

func _ready():
	$Label.text = textName
	
	interactBallon = get_node(interactBallonPath)
	
	var _1 = interactBallon.connect("entered", self, "entered")
	var _2 = interactBallon.connect("exitered", self, "exitered")
	var _3 = interactBallon.connect("interacted", self, "interacted")
	

func interacted():
	emit_signal("interacted")

func entered():
	visible = true
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1, 1), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func exitered():
	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	tween.start()
	
	yield(tween, "tween_all_completed")
	
	visible = false
