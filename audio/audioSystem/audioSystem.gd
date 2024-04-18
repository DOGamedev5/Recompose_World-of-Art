extends Node

onready var musics := {
	"temple in ruins" : preload("res://audio/musics/templeInRuins.mp3")
}

onready var musicPlayer := $musicPlayer

var currentMusic : String

func playMusic(music : String):
	if music == currentMusic:
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

func playSFX(SFX : AudioStream, positional := false, position = Vector2.ZERO, distance = .0, maskArea = 0):
	var newSfx
	if positional:
		newSfx = AudioStreamPlayer2D.new()
		newSfx.position = position
		newSfx.max_distance = distance
		newSfx.area_mask = maskArea
	else:
		newSfx = AudioStreamPlayer.new()
	
	newSfx.stream = SFX
	newSfx.set_bus("SFX")
	newSfx.connect("finished", newSfx, "queue_free")
	
	get_tree().get_root().add_child(newSfx)
	newSfx.play()
