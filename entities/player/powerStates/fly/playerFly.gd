extends PlayerBase

func _ready():
	$Sprite.visible = Network.is_owned(OwnerID)

func _physics_process(_delta):
	motion = Vector2(
		Global.handInputAxis("ui_left", "ui_right", OwnerID),
		Global.handInputAxis("ui_up", "ui_down", OwnerID)
	).normalized() * MAXSPEED
	
	motion = move_and_slide(motion)


func _on_VisibilityNotifier2D_screen_exited():
	if camera.limit_top > global_position.y:
		global_position.y = camera.limit_top + 32
	if camera.limit_bottom < global_position.y:
		global_position.y = camera.limit_bottom - 32
	if camera.limit_left > global_position.x:
		global_position.x = camera.limit_left + 64
	if camera.limit_right < global_position.x:
		global_position.x = camera.limit_right - 64

