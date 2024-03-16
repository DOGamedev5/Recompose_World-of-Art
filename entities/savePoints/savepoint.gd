extends Node2D

export var roomId := 0
export var world := "paintWorld"

func saveData(_player):
	var data = Global.save
	data.player["position"] = position
	data.world["currentRoomID"] = roomId
	data.world["currentWorld"] = world
	Global.saveData(Global.savePath, data)
	
