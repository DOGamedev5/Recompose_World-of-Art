extends Node2D
class_name PuppetPlayer

onready var texture := $Sprite
export var netOwner : int

func _init(global_pos : Vector2):
	global_position = global_pos

func _updateVisual(sprite : Texture, pos : Vector2, frames : Vector2, currentFrame : int):
	texture.texture = sprite
	texture.hframes = frames.x
	texture.vframes = frames.y
	texture.frame = currentFrame
