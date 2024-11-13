extends MarginContainer

onready var initial = $"../initial"
onready var saves = $"../saves"
onready var parent = $"../"
onready var buttons = {
	exit = $VBoxContainer/exit,
	simpleLight = $VBoxContainer/HBoxContainer3/VBoxContainer2/HBoxContainer/simpleLight,
	shadow = $VBoxContainer/HBoxContainer3/VBoxContainer2/HBoxContainer2/shadow
}
onready var slides := {
	music = $VBoxContainer/HBoxContainer3/VBoxContainer/music,
	sfx = $VBoxContainer/HBoxContainer3/VBoxContainer/sound
}

onready var languages := $VBoxContainer/HBoxContainer3/VBoxContainer/languages

var current := false

func _ready():
	buttons.simpleLight.pressed = Global.options.simpleLight
	buttons.shadow.pressed = Global.options.shadows
	
	slides.music.set_value(Global.options.musicVolume)
	slides.sfx.set_value(Global.options.sfxVolume)
	
	for locale in Global.languagesID:
		
		languages.add_item("{lang}".format({"lang" : "lang_" + locale}))
		
		if locale == Global.options.lang:
			languages.select(languages.get_item_count()-1)

func enter():
	$VBoxContainer/exit.grab_focus()

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

func _on_vsync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	Global.options.vsync = button_pressed
	Global.saveData(Global.optionsSavePath, Global.options)
	
func _on_languages_item_selected(index):
	Global.set_languege(index)
	

