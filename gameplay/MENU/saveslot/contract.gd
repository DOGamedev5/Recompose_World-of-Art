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
	
	if _dir.file_exists(savePath + FileSystemHandler.gameSaveFile):
		var dataPlayer = FileSystemHandler.loadDataResource(savePath+FileSystemHandler.gameSaveFile)
		if not dataPlayer.played:
			clearContract()
		else:
			fillContract()
	else:
		clearContract()

func oldVersionHandler(playerData, worldData):
	if playerData.version != "v0.9.5":
		FileSystemHandler.deleteDirArchives(savePath)
		
		playerData = SaveGame.new()
		worldData = FileSystemHandler.generateWorldData()
		FileSystemHandler.saveDataResource(savePath + FileSystemHandler.gameSaveFile, playerData)
		FileSystemHandler.saveDataJSON(savePath + FileSystemHandler.worldSaveFile, worldData)
	
	return [playerData, worldData]

func fillContract():
	FileSystemHandler.createFileData(savePath)
	
	var dataPlayer = FileSystemHandler.loadDataResource(savePath + FileSystemHandler.gameSaveFile)
	var dataWorld = FileSystemHandler.loadDataJSON(savePath + FileSystemHandler.worldSaveFile)
	
	var handledData = oldVersionHandler(dataPlayer, dataWorld)
	dataPlayer = handledData[0]
	dataWorld = handledData[1]
	
	$texture/name.text = dataPlayer.player["playerProperties"]["name"]
	$texture/world.text = dataPlayer.currentWorld
	
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
	
	FileSystemHandler.loadGameData(savePath)
	loadGame()
	
	get_tree().root.set_disable_input(false)
	

func loadGame(): # what
	LoadSystem.openScreen()
	LoadSystem.addToQueueChangeScene("res://worlds/" + Global.save.currentWorld + "/world.tscn")

func deleted():
	clearContract()
	FileSystemHandler.deleteDirArchives(savePath)

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
	
		if _dir.file_exists(savePath + FileSystemHandler.gameSaveFile):
			var dataPlayer = FileSystemHandler.loadDataResource(savePath + FileSystemHandler.gameSaveFile)
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
