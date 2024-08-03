extends Node2D

func saveData():
	Global.save.player["position"] = global_position
	Global.save.played = true
	Global.saveGameData()
