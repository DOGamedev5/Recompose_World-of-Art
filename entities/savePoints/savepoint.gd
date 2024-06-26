extends Node2D

func saveData():
	var data = Global.save
	
	data.player["position"] = position
	
	data.world["currentRoom"] = Global.currentRoom
	
	data.played = true
	
	Global.saveGameData(Global.savePath, data)
	
