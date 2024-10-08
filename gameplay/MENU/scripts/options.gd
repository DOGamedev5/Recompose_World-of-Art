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

onready var languages := $MarginContainer/VBoxContainer/HBoxContainer3/VBoxContainer/languages

var current := false

func _ready():
	buttons.simpleLight.pressed = Global.options.simpleLight
	buttons.shadow.pressed = Global.options.shadows
	
	slides.music.set_value(Global.options.musicVolume)
	slides.sfx.set_value(Global.options.sfxVolume)
	
	var langs := []
	
	if not Global.options.lang:
		Global.options.lang = TranslationServer.get_locale()
		Global.saveData(Global.optionsSavePath, Global.options)
	else:
		TranslationServer.set_locale(Global.options.lang)
	
	for locale in TranslationServer.get_loaded_locales():
		var lang := TranslationServer.get_locale_name(locale)
		if langs.has(lang): continue
		
		languages.add_item("{locale} / ({lang})".format({"locale" : locale, "lang" : lang}))
		langs.append(lang)
		
		if locale == Global.options.lang:
			languages.select(languages.get_item_count())

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

func _on_vsync_toggled(button_pressed):
	OS.vsync_enabled = button_pressed
	Global.options.vsync = button_pressed
	Global.saveData(Global.optionsSavePath, Global.options)
	
func _on_languages_item_selected(index):
	var lang : String = languages.get_item_text(languages.get_item_index(index))
	var locale := lang.get_slice("/", 0)

	TranslationServer.set_locale(locale)
	Global.options.lang = TranslationServer.get_locale()
	Global.saveData(Global.optionsSavePath, Global.options)
	
