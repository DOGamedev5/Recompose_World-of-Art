extends Node

var _file := File.new()
var _dir := Directory.new()

func fileExist(dataPath):
	return _file.file_exists(dataPath)

func saveDataResource(dataPath, data : Resource):
	var _1 = ResourceSaver.save(dataPath, data)

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

func createFileData(path):
	var _error := _dir.make_dir_recursive(path + "/worldRooms")
	
	if not fileExist(path + "save.tres"):
		saveDataResource(path + "save.tres", SaveGame.new())
		saveDataJSON(path + "roomData.json", Global.generateRoomData())
		
	elif not fileExist(path + "roomData.json"):
		var roomData : Dictionary = Global.generateRoomData()
		
		saveDataJSON(path + "roomData.json", roomData)


func saveGameData(position = null):
	Global.save.player["position"] = position if position else Global.player.global_position
	Global.save.played = true
	
	saveDataResource(Global.savePath + "save.tres", Global.save)
	saveDataJSON(Global.savePath + "roomData.json", Global.currentRoom)
	
	for path in Global.roomsToSave.keys():
		saveDataJSON(path, Global.roomsToSave[path])

func loadGameData(dataPath):
	Global.save = loadDataResource(dataPath + "save.tres")
	Global.currentRoom = loadDataJSON(dataPath + "roomData.json")
	
	Global.savePath = dataPath

func deleteFileData(path):
	var _Dir := Directory.new()
	deleteDirArchives(_Dir, path)

func deleteDirArchives(dir : Directory, path, deleteItself := false):
	if dir.open(path) == OK:
		var _1 = dir.list_dir_begin(true)
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				deleteDirArchives(Directory.new(), path + file_name + "/", true) 
			else:
				var _2 = dir.remove(file_name)
			
			file_name = dir.get_next()
		
		if deleteItself:
			var _2 = dir.remove(path)
	
	
