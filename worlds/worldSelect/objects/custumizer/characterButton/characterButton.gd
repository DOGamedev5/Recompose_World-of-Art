extends PanelContainer

export var toggled := false setget _toggled
export var spriteName := "lodrofo"
export(Texture) var texture

signal selected(spriteName, texture)

func _ready():
	$margin/sprite.texture = texture

func _toggled(value):
	toggled = value
	$button.pressed = value
	if not value or not is_instance_valid(get_parent()): return
	emit_signal("selected", spriteName, texture)
	for child in get_parent().get_children():
		if child.has_method("_textureChanged") and child != self:
			child.toggled = false

func _textureChanged(value):
	$margin/sprite.texture = value
