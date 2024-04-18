extends EnemyBase

var direction := 1
var velocity := 500

func _ready():
	if fliped:
		direction = -1
	
	$Effect3.flip_h = fliped
	$CollisionShape2D.position.x = $CollisionShape2D.position.x * direction

func _physics_process(_delta):
	var _1 = move_and_slide(Vector2(velocity * direction, 0), Vector2.UP)
	
	if is_on_wall():
		$AnimationTree["parameters/playback"].travel("collide")
		velocity = 0
	
	if ($AnimationTree["parameters/playback"].get_current_node() == "collide" and
		$AnimationTree["parameters/playback"].get_current_play_position() >= 0.29):
		queue_free()
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "collide":
		queue_free()
