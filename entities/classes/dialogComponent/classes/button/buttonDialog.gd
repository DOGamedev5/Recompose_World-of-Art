extends Control

onready var rect = $NinePatchRect
onready var label = $NinePatchRect/Label

export(String) var text

enum stats {
	NORMAL,
	SELECTED,
	PRESSED
}

var currentStat = stats.NORMAL

func _ready():
	label.text = text
	setSize()

func updateTexture(stat = currentStat):
	$NinePatchRect["region_rect"].position.x = 96 * stat
	currentStat = stat

func setSize():
	label.set_text(text)
	var size = $NinePatchRect/Label.text.length()*16 + 16

	$NinePatchRect.rect_min_size.x = size
	
	rect_min_size.x = size
