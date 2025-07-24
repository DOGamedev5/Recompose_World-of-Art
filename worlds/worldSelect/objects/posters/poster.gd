extends Area2D

onready var offset := Vector2.ZERO
onready var rotationOffset := 0.0
onready var time := 0.0
export var lockPos := false

func _process(delta):
	offset.x = lerp(offset.x, sin(time)*8, delta*4)
	offset.y = lerp(offset.y, cos(time)*8, delta*8.5)
	rotationOffset = lerp_angle(rotationOffset, sin(time)*0.2, delta*0.55)
	
	time += delta
	if time >= PI*2:
		time -= PI*2
	
	if not lockPos and $AnimationPlayer.is_playing():
		$Poster1.position = lerp($Poster1.position, offset, delta*3) 
		$Poster1.rotation = lerp_angle($Poster1.rotation, rotationOffset, delta*3)
	else:
		$Poster1.position = lerp($Poster1.position, Vector2.ZERO, delta*5)
		$Poster1.rotation = lerp_angle($Poster1.rotation, 0, delta*4)
	

func _on_poster_area_entered(_area):
	$AnimationPlayer.play("animation")

func _on_poster_area_exited(_area):
	$AnimationPlayer.play("RESET")
