extends ParallaxBackground

onready var tween := $Tween

func _ready():
	tween.interpolate_property($ParallaxLayer3,"motion_offset", Vector2.ZERO, -$ParallaxLayer3["motion_mirroring"], 50)
	tween.interpolate_property($ParallaxLayer2,"motion_offset", Vector2.ZERO, -$ParallaxLayer2["motion_mirroring"], 60)
	tween.start()


func _on_Tween_tween_completed(object, key):
	if object.name == "ParallaxLayer3":
		tween.interpolate_property($ParallaxLayer3, "motion_offset", Vector2.ZERO, -$ParallaxLayer3["motion_mirroring"], 50)
	if object.name == "ParallaxLayer2":
		tween.interpolate_property($ParallaxLayer2, "motion_offset", Vector2.ZERO, -$ParallaxLayer2["motion_mirroring"], 60)
