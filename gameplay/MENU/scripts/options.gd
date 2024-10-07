extends Control

onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var buttons = {
	exit = $MarginContainer/VBoxContainer/exit,
	simpleLight = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/HBoxContainer/simpleLight,
	shadow = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer2/HBoxContainer2/shadow
}
onready var slides := {
	music = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/music,
	sfx = $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/sound
}

var current := false

func _ready():

	
	buttons.simpleLight.pressed = Global.options.simpleLight
	buttons.shadow.pressed = Global.options.shadows
	
	slides.music.set_value(Global.options.musicVolume)
	slides.sfx.set_value(Global.options.sfxVolume)

func enter():
	$MarginContainer/VBoxContainer/exit.grab_focus()

func changed():
	pass

func _on_exit_pressed():
	parent.transition(initial, [self, saves])

func _on_simpleLight_toggled(button_pressed):
	Global._setSimpleLight(button_pressed)
	Global.saveData(Global.optionsSavePath, Global.options) 

func _on_shadow_toggled(button_pressed):
	Global._setShadow(button_pressed)
	Global.saveData(Global.optionsSavePath, Global.options)

func _on_music_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("music"), linear2db(value))
	Global.options.musicVolume = value

func _on_sound_value_changed(value):
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), linear2db(value))
	Global.options.sfxVolume = value

func _on_drag_ended(_value_changed):
	Global.saveData(Global.optionsSavePath, Global.options)
	
