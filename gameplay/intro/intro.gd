extends CanvasLayer

onready var menu = preload("res://gameplay/MENU/menu.tscn")
onready var total = $MarginContainer/HBoxContainer/total
onready var file := $MarginContainer/HBoxContainer/file
onready var totalLoaders := 0

var allLoaded := false

func _ready():
	LoadedObjects.connect("allTexturesLoaded", self, "exit")
	LoadedObjects.loadDirectory("res://entities/player/powerStates/", "player", ".png")
	LoadedObjects.loadDirectory("res://entities/player/powerStates/", "powerPlayers", ".tscn", 0)

func _process(_delta):
	LoadedObjects.process()
	if LoadedObjects.loaders.size() > totalLoaders: totalLoaders = LoadedObjects.loaders.size()
	
	if LoadedObjects.currentSegments != LoadedObjects.totalSegments:
		total.text = "Loading Textures... Segments: {current}/{total}".format({"current" : LoadedObjects.alreadyLoaded, "total" : totalLoaders})
	else:
		total.text = "All textures are loaded."
	
	if LoadedObjects.loaders.size() > 0:
		var text : String = LoadedObjects.loaders[0]["path"]
		if text.length() > 50:
			text = "..."+text.substr(text.length() - 50, -1)

		file.text = text
	else:
		file.text = "Done!(press E to skip intro)"

func _input(event):
	if event.is_action_pressed("interact") and allLoaded:
		var _1 = get_tree().change_scene_to(menu)

func _on_AnimationPlayer_animation_finished(_anim_name):
	if allLoaded:
		var _1 = get_tree().change_scene_to(menu)

func exit():
	$Tween.interpolate_property($MarginContainer, "modulate", Color.white, Color.transparent, 0.3, Tween.TRANS_CUBIC, Tween.EASE_OUT, 1.5)
	$Tween.start()
	allLoaded = true
	if not $AnimationPlayer.is_playing():
		var _1 = get_tree().change_scene_to(menu)
