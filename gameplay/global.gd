extends Node

export var simpleLight := false

var save : SaveResource
var savePath : String
var _file := File.new()

signal simpleLightChanged(value)

func _ready():
	var _1 = connect("simpleLightChanged", self, "_setSimpleLight")	

func _setterSimpleLight(value):
	simpleLight = value
	emit_signal("simpleLightChanged", value)

func compareFloats(a : float, b : float, tolerance := 0.000001):
	return abs(a - b) < tolerance

func _input(_event):
	if Input.is_action_just_pressed("quit"):
		get_tree().quit()

func setupPlayer(player):
	player.position = save.player["position"]

func _setSimpleLight(value):
	
	simpleLight = value

func saveExist(dataPath):
	return _file.file_exists(dataPath)

func saveData(dataPath, data := SaveResource.new()):
	var ERROR := _file.open(dataPath, File.WRITE)
	
	if ERROR != OK:
		printerr("CAN'T OPEN THE FILE %s, ABORT SAVE, ERROR: %s" % [dataPath, ERROR])
		return
	
	var jsonData := {}
	
	jsonData["player"] = _saveData_Dictionary(data.player)
	jsonData["world"] = _saveData_Dictionary(data.world)
	
	var JSONstr = JSON.print(jsonData)
	_file.store_string(JSONstr)
	_file.close()

func loadData(dataPath, data : Resource):
	var ERROR := _file.open(dataPath, File.READ)
	
	if ERROR != OK:
		printerr("CAN'T OPEN THE FILE %s, ABORT LOAD, ERROR: %s" % [dataPath, ERROR])
		return
	
	savePath = dataPath
	
	var content := _file.get_as_text()
	_file.close()
	
	var loadedData : Dictionary = JSON.parse(content).result
	
	for key in loadedData.keys():
		data[key] = _loadData_Dictionary(loadedData[key])
	

	save = data

func _saveData_Dictionary(dic : Dictionary) -> Dictionary:
	var jsonData := {}
	
	for valueKey in dic.keys():
		var value = dic[valueKey]
		if value is Vector2:
			jsonData[valueKey] = _saveData_Vector2(value)
			continue
			
		elif value is Dictionary:
			jsonData[valueKey] = _saveData_Dictionary(value)
			continue
		
		
		jsonData[valueKey] = value
	
	return jsonData

func _saveData_Vector2(vector : Vector2) -> Dictionary:
	var jsonData := {}
	
	jsonData["x"] = vector.x
	jsonData["y"] = vector.y
	
	return jsonData

func _loadData_Dictionary(dic : Dictionary) -> Dictionary:
	var data := {}
	
	for valueKey in dic.keys():
		var value = dic[valueKey]
		if value is Vector2:
			data[valueKey] = _loadData_Vector2(value)
			continue
			
		elif value is Dictionary:
			data[valueKey] = _loadData_Dictionary(value)
			continue
		
		data[valueKey] = value
	
	return data

func _loadData_Vector2(vector : Dictionary) -> Vector2:
	var value : Vector2
	
	value = Vector2(vector["x"], vector["y"])
	
	return value
