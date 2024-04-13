extends Control

var debugPanel := false
onready var player = $"../../"

onready var proprietyLabels := {
	"currentState" : $DEBUG/PanelContainer/VBoxContainer/currentState,
	"motion" : $DEBUG/PanelContainer/VBoxContainer/motion,
	"running" : $DEBUG/PanelContainer/VBoxContainer/running,
	"onSlope" : $DEBUG/PanelContainer/VBoxContainer/onSlope,
	"snapDesatived" : $DEBUG/PanelContainer/VBoxContainer/snapDesatived,
	"snapLenght" : $DEBUG/PanelContainer/VBoxContainer/snapLenght,
	"FPS" : $DEBUG/PanelContainer/VBoxContainer/FPS
}

func _ready():
	$DEBUG/PanelContainer/VBoxContainer/simpleLight.pressed = Global.options.simpleLight

func _input(_event):
	if Input.is_action_just_pressed("Debug"):
		debugPanel = !debugPanel
		$DEBUG.visible = debugPanel
	
func _process(_delta):
	proprietyLabels["currentState"].text = (
		"current State: " + player.stateMachine.currentState.name)

	proprietyLabels["motion"].text = (
		"Motion: " + str(player.motion))
		
	proprietyLabels["running"].text = (
		"Running: " + str(player.running))
		
	proprietyLabels["onSlope"].text = (
		"On slope: " + str(player.onSlope()))
		
	proprietyLabels["snapDesatived"].text = (
		"snap desatived: " + str(player.snapDesatived))
	
	proprietyLabels["snapLenght"].text = (
		"snap lenght: " + str(player.currentSnapLength))
	
	proprietyLabels["FPS"].text = (
		"FPS: " + str(Engine.get_frames_per_second()))
	

func debugButtonPressed():
	player.get_parent().emit_signal("changeRoom", "res://debugRoom.tscn", 0)

func simpleLightToggled():
	var value = $DEBUG/PanelContainer/VBoxContainer/simpleLight.pressed
	Global.emit_signal("simpleLightChanged", value)
