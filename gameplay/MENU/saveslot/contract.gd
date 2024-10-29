extends TextureButton

export var saveID := 1

onready var tween := $Tween

const dirSavePath = "user://userData/saves/save%d/"
const sfx := preload("res://gameplay/MENU/audio/contractSFX.ogg")

var savePath : String
var hovered := false

func _ready():
	savePath = dirSavePath % saveID
	
	var _dir = Directory.new()
	
	if _dir.file_exists(savePath + "save.tres"):
		var dataPlayer = Global.loadData(savePath+"save.tres")
		if not dataPlayer.played:
			clearContract()
		else:
			fillContract()
	else:
		clearContract()

func fillContract():
	Global.createFileData(savePath)
		
	var dataPlayer = Global.loadData(savePath+"save.tres")
	
	$texture/name.text = dataPlayer.player["playerProperties"]["name"]
	
	var dataWorld = Global.loadData(savePath+"roomData.tres")
	$texture/world.text = dataWorld.getWorld()
	
	$texture.modulate = Color.white

func clearContract():
	$texture/name.text = ""
	$texture/world.text = ""
	
	$texture.modulate = Color(1, 1, 1, 0.7)

func confirmed():
	fillContract()
	randomize()
	var confirmOffset := Vector2(randi() % 5 - 2, randi() % 5 - 2)*2
	
	var rotation := rand_range(-12, 12)
		
	$texture/Control.rect_position = Vector2(194, 338) + confirmOffset
	$texture/Control/confirm.rect_rotation = rotation

	$AnimationPlayer.play("confirmed")
	yield($AnimationPlayer, "animation_finished")
	
	Global.createFileData(savePath)
	Global.loadGameData(savePath)
	
	LoadSystem.loadScene(get_tree().current_scene, "res://worlds/main.tscn")
	get_tree().root.set_disable_input(false)
	

func deleted():
	clearContract()
	Global.deleteFileData(savePath)

func _on_contract_focus_entered():
	hovered = true
	
	if focus_neighbour_left:
		get_node(focus_neighbour_left).removeFocus()
		
	if focus_neighbour_right:
		get_node(focus_neighbour_right).removeFocus()
	
	if not pressed:
		$texture/select.visible = true
		$texture/select.modulate = Color(1,1,1, 0.5)
	else:
		$texture/select.visible = true
		$texture/select.modulate = Color.white

func removeFocus():
	if pressed: return
	tween.interpolate_property($texture, "rect_position", $texture["rect_position"], Vector2.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
	tween.start()

func _on_contract_focus_exited():
	hovered = false
	$texture/select.visible = pressed

func _on_contract_toggled(button_pressed):
	if button_pressed:
		$texture/select.modulate = Color(1,1,1, 1)
		tween.interpolate_property($texture, "rect_position", $texture["rect_position"], Vector2(0, -48), 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
		for child in $"../".get_children():
			if child.name == name: continue
			
			child.pressed = false
		
		var _dir = Directory.new()
	
		if _dir.file_exists(savePath + "save.tres"):
			var dataPlayer = Global.loadData(savePath+"save.tres")
			$"../../HBoxContainer2/erase".disabled = not dataPlayer.played
		else:
			$"../../HBoxContainer2/erase".disabled = true
			
	else:
		if not verifyDesselect():
			pressed = true
			$"../../HBoxContainer2/start".grab_focus()
			return
		
		$texture/select.modulate = Color(1,1,1, 0.5)
		$texture/select.visible = hovered
		tween.interpolate_property($texture, "rect_position", $texture["rect_position"], Vector2.ZERO, 0.2, Tween.TRANS_CUBIC, Tween.EASE_IN)
		
	tween.start()

func verifyDesselect():
	for child in $"../".get_children():
		if child.name == name: continue
		
		if child.pressed:
			return true
	
	return false

func playSFX():
	AudioManager.playSFX(sfx)
