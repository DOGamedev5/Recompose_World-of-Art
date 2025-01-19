extends KinematicBody2D

export var linePosition := Vector2(-1433, -1697)

export var lineStart := Vector2.ZERO

export var motion := 0
var actualMotion := 0

signal elevatorInteracted

func _physics_process(delta):
	var pos := to_local(lineStart)
	
	$Line2D.points[1].y = pos.y
	
	if actualMotion != motion:
		actualMotion = lerp(actualMotion, motion, 0.2*delta)
	
	position.y += actualMotion*delta



func _on_interactBallon_interacted():
	$AnimationTree["parameters/playback"].start("lever")
	
	emit_signal("elevatorInteracted")

func _on_VisibilityEnabler2D_screen_entered():
	$CollisionShape2D.disabled = false
	$CollisionShape2D2.disabled = false
	$CollisionShape2D3.disabled = false

func _on_VisibilityEnabler2D_screen_exited():
	$CollisionShape2D.disabled = true
	$CollisionShape2D2.disabled = true
	$CollisionShape2D3.disabled = true

