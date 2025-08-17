extends Node

onready var musics := {
	"temple in ruins" : preload("res://audio/musics/templeInRuins.mp3"),
	"recompose" : preload("res://audio/musics/recompose.ogg"),
	"paintCaverns" : preload("res://audio/musics/paintCaverns.ogg")
}

onready var musicPlayer := $musicPlayer

var currentMusic : String

func playMusic(music : String = currentMusic):
	if music == currentMusic:
		if not musicPlayer.playing:
			musicPlayer.playing = true
		
		return
	
	if musicPlayer.playing:
		stop()
	
	_setMusic(music)

func _setMusic(music : String):
	musicPlayer.stream = musics[music]
	currentMusic = music
	musicPlayer.playing = true

func stop():
	musicPlayer.playing = false

func playSFX(SFX : AudioStream, properties := {"volume_db" : 0}, positional := false, position := Vector2.ZERO, distance := .0, maskArea := 1):
	var newSfx
	
	if positional:
		newSfx = AudioStreamPlayer2D.new()
		newSfx.global_position = position
		newSfx.max_distance = distance
		newSfx.area_mask = maskArea
		
		
	else:
		newSfx = AudioStreamPlayer.new()
		
	newSfx.autoplay = true
	newSfx.stream = SFX
	for key in properties:
		newSfx[key] = properties[key]
	
	newSfx.set_bus("SFX")
	newSfx.connect("finished", newSfx, "queue_free")
	
	Global.world.add_child(newSfx)
	newSfx.play()
