extends Sprite

func _ready():
#	$Tween.interpolate_property(self, "normalOffset", Vector2(-1, -1), Vector2(1, 1), 1)
	$Tween.interpolate_method(self, "updateOffset", Vector2(-1, -1), Vector2(1, 1), 20)
	$Tween.start()

func _on_Tween_tween_completed(_object, _key):
#	$Tween.interpolate_property(self, "normalOffset", Vector2(-1, -1), Vector2(1, 1), 1)
	$Tween.interpolate_method(self, "updateOffset", Vector2(-1, -1), Vector2(1, 1), 20)
	$Tween.start()

func updateOffset(value):
	material["shader_param/normalOffset"] = value
