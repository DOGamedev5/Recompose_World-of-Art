extends CanvasLayer

onready var parent := get_parent()
onready var languages := $Panel/VBoxContainer/HBoxContainer2/VBoxContainer/languages

onready var propertiesList = {
	"simpleLight" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer/simpleLight,
	"shadows" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer2/shadow,
	"vsync" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer3/vsync,
	"music" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer/music,
	"sfx" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer/sound,
	"color" : $Panel/VBoxContainer/HBoxContainer2/VBoxContainer2/HBoxContainer4/color
}


func _ready():
	
	for locale in Global.languagesID:
		
		languages.add_item("{lang}".format({"lang" : "lang_" + locale}))
		
		if locale == Global.options.lang:
			languages.select(languages.get_item_count()-1)
		
	propertiesList["simpleLight"].pressed = Global.options.simpleLight
	propertiesList["shadows"].pressed = Global.options.shadows
	propertiesList["vsync"].pressed = Global.options.vsync
	propertiesList["color"].pressed = Global.options.colorEffect
	
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
			$Panel/VBoxContainer/HBoxContainer/close.grab_focus()
		else:
			if Global.player.cinematic:
				parent.currentScreen = "CINE"
			else:
				parent.currentScreen = "HUD"

func _on_close_pressed():
	visible = false
	parent.visible = true

func _on_quit_pressed():
	Network.leaveLobby()
	get_tree().quit()

func _on_menu_pressed():
	Network.leaveLobby()	
	get_tree().paused = false
	Global.in_game = false
	LoadSystem.openScreen()
	LoadSystem.addToQueueChangeScene("res://gameplay/MENU/menu.tscn")

func _on_configurations_visibility_changed():
	get_tree().paused = visible and Network.lobbyID == -1

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value))
	Global.options.musicVolume = value

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	Global.options.sfxVolume = value

func _on_drag_ended(_value_changed):
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)

func _on_simpleLight_toggled(button_pressed):
	Global._setSimpleLight(button_pressed)
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)

func _on_shadow_toggled(button_pressed):
	Global._setShadow(button_pressed)
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)

func _on_vsync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	Global.options.vsync = button_pressed
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)

func _on_languages_item_selected(index):
	Global.set_languege(index)

func _on_color_toggled(button_pressed):
	Global._setColorEffect(button_pressed)
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)
