extends Control

var debugPanel := false
onready var player = $"../../"

onready var proprietyLabels := {
	"currentState" : $PanelContainer/VBoxContainer/currentState,
	"motion" : $PanelContainer/VBoxContainer/motion,
	"running" : $PanelContainer/VBoxContainer/running,
	"onSlope" : $PanelContainer/VBoxContainer/onSlope,
	"snapDesatived" : $PanelContainer/VBoxContainer/snapDesatived,
	"snapLenght" : $PanelContainer/VBoxContainer/snapLenght,
	"FPS" : $PanelContainer/VBoxContainer/FPS
}

func _ready():
	$PanelContainer/VBoxContainer/simpleLight.pressed = Global.options.simpleLight

func _input(_event):
	if Input.is_action_just_pressed("Debug"):
		debugPanel = !debugPanel
		visible = debugPanel
	
func _process(_delta):
	DEBUGSetup()
	
func DEBUGSetup():
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
	player.get_parent().loadRoom("res://debugRoom.tscn", 0)

func simpleLightToggled():
	var value = $PanelContainer/VBoxContainer/simpleLight.pressed
	Global.emit_signal("simpleLightChanged", value)
