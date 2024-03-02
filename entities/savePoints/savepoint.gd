extends Node2D

export var roomId := 0
export var world := "paintWorld"

func saveData():
	var data = Global.save
	data.player["position"] = position
	data.world["currentRoomID"] = roomId
	data.world["currentWorld"] = world
	var _1 = ResourceSaver.save(Global.savePath, data)
	
