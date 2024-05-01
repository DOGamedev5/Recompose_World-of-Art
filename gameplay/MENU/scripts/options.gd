extends Control

onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var buttons = {
	exit = $Panel/buttonMenu,
	simpleLight = $Panel/VBoxContainer/HBoxContainer/CheckButton
}
onready var slides := {
	music = $Panel/VBoxContainer/music,
	sfx = $Panel/VBoxContainer/sound
}



var current := false

func _ready():
	if not Global.saveExist(Global.optionsSavePath):
		Global.saveData(Global.optionsSavePath, OptionsSave.new())
	
	Global.options = Global.loadData(Global.optionsSavePath)
	
	buttons.simpleLight.pressed = Global.options.simpleLight
	
	slides.music.set_value(Global.options.musicVolume)
	slides.sfx.set_value(Global.options.sfxVolume)

func enter():
	for button in buttons:
		buttons[button].active = true

func changed():
	for button in buttons:
		buttons[button].active = false

func _on_exitOptions_pressed():
	parent.transition(initial, [self, saves])

func _on_simpleLight_toggled(button_pressed):
	Global.options.simpleLight = button_pressed
	Global.saveData(Global.optionsSavePath, Global.options) 

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value))
	Global.options.musicVolume = value

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	Global.options.sfxVolume = value

func _on_drag_ended(_value_changed):
	Global.saveData(Global.optionsSavePath, Global.options)
