extends Control

var debugPanel := false
onready var player = $"../../"

onready var proprietyLabels := {
	"currentState" : $DEBUG/PanelContainer/VBoxContainer/currentState,
	"motion" : $DEBUG/PanelContainer/VBoxContainer/motion,
	"running" : $DEBUG/PanelContainer/VBoxContainer/running,
	"onSlope" : $DEBUG/PanelContainer/VBoxContainer/onSlope,
	"snapDesatived" : $DEBUG/PanelContainer/VBoxContainer/snapDesatived,
	"snapLenght" : $DEBUG/PanelContainer/VBoxContainer/snapLenght
}

func _input(_event):
	if Input.is_action_just_pressed("Debug"):
		debugPanel = !debugPanel
		$DEBUG.visible = debugPanel
	
func _process(delta):
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


func debugButtonPressed():
	player.get_parent().emit_signal("changeRoom", "res://debugRoom.tscn", 0)

