extends Node

var _file := File.new()
var _dir := Directory.new()

const worldSaveFile := "worldData.json"
const gameSaveFile := "save.tres"

func fileExist(dataPath):
	return _file.file_exists(dataPath)

func saveDataResource(dataPath, data : Resource):
	var error := ResourceSaver.save(dataPath, data)
	if error != OK:
		push_warning("can't save '{}', error {}".format([dataPath, error]))

func loadDataResource(dataPath):
	return ResourceLoader.load(dataPath, "", true)

func saveDataJSON(datapath : String, data):
	if not data is String:
		data = JSON.print(data, "\t")
	
	var _error := _file.open(datapath, File.WRITE)
	_file.store_line(data)
	_file.close()

func loadDataJSON(datapath : String):
	_file.open(datapath, File.READ)
	var text := _file.get_as_text() 
	
	var result := JSON.parse(text)
	if result.error != OK:
		print_debug("error loading JSON: {name} at line {line}".format({"name" : result.error_string, "line" : result.error_line}))
		push_error("error loading JSON: {name} at line {line}".format({"name" : result.error_string, "line" : result.error_line}))
	
	_file.close()
	
	return result.result

func generateWorldData():
	return {
		"sandDesert" : {
			
		}
	}

func createFileData(path):
	var _error := _dir.make_dir_recursive(path + "/worldRooms")
	
	if not fileExist(path + gameSaveFile):
		saveDataResource(path + gameSaveFile, SaveGame.new())
		saveDataJSON(path + worldSaveFile, generateWorldData())
		
	elif not fileExist(path + worldSaveFile):
		var roomData : Dictionary = {}
		
		saveDataJSON(path + worldSaveFile, roomData)

func saveGameData(position = null):
	Global.save.player["position"] = position if position else Global.player.global_position
	Global.save.played = true
	
	saveDataResource(Global.savePath + gameSaveFile, Global.save)
	saveDataJSON(Global.savePath + worldSaveFile, Global.worldData)

func loadGameData(dataPath):
	Global.save = loadDataResource(dataPath + gameSaveFile)
	Global.worldData = loadDataJSON(dataPath + worldSaveFile)
	Global.savePath = dataPath

func deleteFile(filePath):
	var file := File.new()
	var dir := Directory.new()
	var error := file.open(filePath, File.READ_WRITE)
	
	if error == OK:
		var error2 := dir.remove(filePath)
		if error2 != OK:
			push_error("cant erase file '{0}', error {1}".format([filePath, error]))
		
	elif not error in [ERR_FILE_NOT_FOUND, ERR_FILE_NO_PERMISSION]:
		push_error("cant erase file '{0}', error {1}".format([filePath, error]))

func deleteDirArchives(path, deleteItself := false):
	var dir := Directory.new()
	var error := dir.open(path)
	
	if error != OK:
		push_warning("cant open '{0}', error: {1}".format([path, error]))
		return
		
	var error2 = dir.list_dir_begin(true)
	if error2: push_warning("cant begin dir '{0}', error {1}".format([path, error2]))
	
	var file_name = dir.get_next()
	while file_name != "":
		if dir.current_is_dir():
			deleteDirArchives(path + file_name + "/", true)
			file_name = dir.get_next()
			continue
		
		var error3 = dir.remove(file_name)
		if error3 != OK: push_warning("cant delete '{0}', error: {1}".format([file_name, error]))
			
		file_name = dir.get_next()
	
	if deleteItself:
		var error3 = dir.remove(path)
		if error3 != OK:
			push_warning("cant delete '{0}', error: {1}".format([path, error]))
	
