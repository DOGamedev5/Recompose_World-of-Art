extends CanvasLayer

var debugPanel := false

onready var proprietyLabels := {
	"currentState" : $PanelContainer/VBoxContainer/currentState,
	"motion" : $PanelContainer/VBoxContainer/motion,
	"running" : $PanelContainer/VBoxContainer/running,
	"onSlope" : $PanelContainer/VBoxContainer/onSlope,
	"snapDesatived" : $PanelContainer/VBoxContainer/snapDesatived,
	"snapLenght" : $PanelContainer/VBoxContainer/snapLenght,
	"FPS" : $PanelContainer/VBoxContainer/FPS
}

var selectedWorld : String

func _ready():
	visible = false
	$PanelContainer/VBoxContainer/simpleLight.pressed = Global.options.simpleLight
	$PanelContainer/VBoxContainer/HBoxContainer2/ToolButton.add_item("rooms", 0)
	$PanelContainer/VBoxContainer/HBoxContainer2/ToolButton.add_item("especialRooms", 1)

func _input(_event):
	if Input.is_action_just_pressed("Debug") and OS.is_debug_build():
		debugPanel = !debugPanel
		visible = debugPanel
	
func _process(_delta):
	DEBUGSetup()

func DEBUGSetup():
	if not is_instance_valid(Global.player): return
	
	if Global.player.stateMachine: proprietyLabels["currentState"].text = (
		"current State: " + Global.player.stateMachine.currentState.name)

	proprietyLabels["motion"].text = (
		"Motion: " + str(Global.player.motion))
		
	proprietyLabels["onSlope"].text = (
		"On slope: " + str(Global.player.onSlope()))
		
	proprietyLabels["snapDesatived"].text = (
		"snap desatived: " + str(Global.player.snapDesatived))
	
	proprietyLabels["snapLenght"].text = (
		"snap lenght: " + str(Global.player.currentSnapLength))
	
	proprietyLabels["FPS"].text = (
		"FPS: " + str(Engine.get_frames_per_second()))
	
	if not Global.player.is_in_group("normal"): return

	proprietyLabels["running"].text = (
		"Running: " + str(Global.player.running))
	
func debugButtonPressed():
	Global.player.get_parent().loadRoom("res://debugRoom.tscn", 0)

func simpleLightToggled():
	var value = $PanelContainer/VBoxContainer/simpleLight.pressed
	Global.emit_signal("simpleLightChanged", value)

func _on_room_pressed():
	$worldSelect.popup()

func _on_worldSelect_dir_selected(dir):
	selectedWorld = dir
	$PanelContainer/VBoxContainer/currentWorld.text = "current World: " + dir

func _on_go_to_room_pressed():
	var roomID = $PanelContainer/VBoxContainer/HBoxContainer/SpinBox.value
	var category = $PanelContainer/VBoxContainer/HBoxContainer2/ToolButton.text
	var room := RoomData.new(roomID, selectedWorld, category, "", 0, "warp", true)
	Global.world.loadRoom(room)
