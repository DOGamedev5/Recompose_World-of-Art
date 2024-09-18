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
	if not $Timer.is_stopped():
		$Timer.paused = true

	tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(1, 1), 0.5, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	tween.start()

func exitered():
	if not tween.is_inside_tree(): yield(tween, "tree_entered")
	
	
	if $Timer.is_inside_tree():
		$Timer.start()
		$Timer.paused = false

func _on_Timer_timeout():
	if interactBallon.canInteract: 
		return
	
	if tween.is_inside_tree():
		tween.interpolate_property(self, "rect_scale", rect_scale, Vector2(0, 0), 0.5, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		tween.start()
		
		yield(tween, "tween_all_completed")
		
#		visible = false
	
