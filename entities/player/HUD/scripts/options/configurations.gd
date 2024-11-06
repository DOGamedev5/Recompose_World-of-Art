extends CanvasLayer

onready var parent := get_parent()

onready var propertiesList = {
	"simpleLight" : $Panel/VBoxContainer/HBoxContainer/CheckButton,
	"music" : $Panel/VBoxContainer/music,
	"sfx" : $Panel/VBoxContainer/sound
}


func _ready():
	
	propertiesList["simpleLight"].pressed = Global.options.simpleLight
	propertiesList["simpleLight"]._on_CheckButton_toggled()
	propertiesList["music"].value = Global.options.musicVolume
	propertiesList["sfx"].value = Global.options.sfxVolume

func _input(_event):
	if Input.is_action_just_pressed("menu") and $"../".currentScreen in ["HUD", "CONF", "CINE"]:
		visible = not visible
		
		parent.HUD.visible = not visible
		if Global.player.cinematic:
			parent.HUD.visible = false
		
		if visible:
			parent.currentScreen = "CONF"
		else:
			if Global.player.cinematic:
				parent.currentScreen = "CINE"
			else:
				parent.currentScreen = "HUD"

func _on_SImpleLight_toggled(button_pressed):
	Global._setSimpleLight(button_pressed)
	Global.saveData(Global.optionsSavePath, Global.options)

func _on_close_pressed():
	visible = false
	parent.visible = true

func _on_quit_pressed():
	get_tree().quit()

func _on_menu_pressed():
	get_tree().paused = false
	LoadSystem.loadScene(Global.world, LoadSystem.MAIN_SCENE, true)

func _on_configurations_visibility_changed():
	get_tree().paused = visible

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value))
	Global.options.musicVolume = value

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	Global.options.sfxVolume = value

func _on_drag_ended(_value_changed):
	Global.saveData(Global.optionsSavePath, Global.options)

func _on_CheckButton_toggled(button_pressed):
	Global._setShadow(button_pressed)
	Global.saveData(Global.optionsSavePath, Global.options)
