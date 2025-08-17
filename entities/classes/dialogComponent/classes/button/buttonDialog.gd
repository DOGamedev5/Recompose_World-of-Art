extends Control

onready var rect = $NinePatchRect
onready var label = $Label

export(String) var text

enum stats {
	NORMAL,
	SELECTED,
	PRESSED
}

var currentStat = stats.NORMAL

func _ready():
#	label.text = text
	setSize()

func updateTexture(stat = currentStat):
	$NinePatchRect["region_rect"].position.x = 96 * stat
	currentStat = stat

func setSize():
	label.text = ""
	
	label.rect_size.x = 0
	label.text = text

func _on_Label_resized():
	if label:
		rect_min_size.x = label.rect_min_size.x + 24
		rect.rect_size.x = label.rect_size.x + 24
