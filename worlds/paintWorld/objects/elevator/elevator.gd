extends Node2D

export var lineDistante := 299
export var linePosition := Vector2(-1433, -1697)

func _ready():
	$Line2D.points[1].y = (linePosition.y - position.y) - $Line2D.position.y

