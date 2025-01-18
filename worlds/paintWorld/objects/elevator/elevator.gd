extends KinematicBody2D

export var linePosition := Vector2(-1433, -1697)

export var lineStart := Vector2.ZERO

var motion := 0
var actualMotion := 0

func _physics_process(delta):
	var pos := to_local(lineStart)
	
	$Line2D.points[1].y = pos.y
	
	if actualMotion != motion:
		actualMotion = lerp(actualMotion, motion, 0.3*delta)
	
	position.y += actualMotion*delta
