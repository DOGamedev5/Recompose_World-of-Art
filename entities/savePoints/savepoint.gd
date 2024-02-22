extends Node2D

export var roomId := 0

func saveData(data = Global.save):
	var save = data
	data.player["position"] = position
	data.world["currentRoomiD"] = roomId
	ResourceSaver.save(Global.savePath, save)
	
