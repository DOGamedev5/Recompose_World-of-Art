extends Node

var playerList = {}

func addPlayer(id):
	playerList[id] = PlayerInfo.new()
	playerList[id].name = String(id)
	playerList[id].set_network_master(id)
	add_child(playerList[id])

func removePlayer(id : int):
	playerList[id].queue_free()
	playerList.erase(id)

func clearPlayers():
	for player in get_children():
		removePlayer(int(player.name))

func getPlayerName(id):
	return playerList[id].playerName

func setPlayerName(id, newName):
	if playerList.has(id):
		playerList[id].playerName = newName

func getPlayer(id):
	return playerList[id]

func getUserPlayer():
	return playerList[get_tree().get_network_unique_id()]
