extends Control

onready var propertiesList = {
	"simpleLight" : $Panel/VBoxContainer/HBoxContainer/CheckButton
}

func _ready():
	propertiesList["simpleLight"].pressed = Global.options.simpleLight

func _input(_event):
	if Input.is_action_just_pressed("menu"):
		visible = not visible
		$"../../HUD".visible = not visible

func _on_SImpleLight_toggled(button_pressed):
	Global.emit_signal("simpleLightChanged", button_pressed)

func _on_close_pressed():
	visible = false
	$"../../HUD".visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().paused = false
	LoadSystem.loadScene($"../../../../", LoadSystem.MAIN_SCENE, true)

func _on_configurations_visibility_changed():
	get_tree().paused = visible
#	Global.setGamePause(visible)
