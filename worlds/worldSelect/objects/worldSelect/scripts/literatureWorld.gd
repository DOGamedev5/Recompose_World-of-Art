extends TextureButton

onready var animation := $AnimationPlayer
var hovered := false

func _on_literatureWorld_focus_entered():
	animation.play("open")

func _on_literatureWorld_focus_exited():
	animation.play_backwards("open")

func _focus_entered():
	if hovered: return
	hovered = true
	animation.play("open")

func _focus_exited():
	if not hovered and is_hovered(): return
	hovered = false
	animation.play_backwards("open")
	
func _mouse_entered():
	if hovered: return
	hovered = true
	animation.play("open")

func _mouse_exited():
	if not hovered and has_focus(): return
	hovered = false
	animation.play_backwards("open")
