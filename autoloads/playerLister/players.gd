extends Node

var playerList = {}
enum {
	netSteam,
	netEnet
}

func addPlayer(id, reference = null, type := netSteam, netOwner := -1):
	if playerList.has(id): return
	
	playerList[id] = PlayerInfo.new()
	playerList[id].name = String(id)

	playerList[id].type = type
	if netOwner == netEnet: playerList[id].netOwner = netOwner
	if reference:
		playerList[id].reference = reference
	
	add_child(playerList[id])

func removePlayer(id : int):
	if not playerList.has(id): return
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

func getPlayerCharater(id : int):
	if playerList.has(id):
		return playerList[id].character
	else: "lodrofo"

func setPlayerCharater(id : int, character : String):
	playerList[id].character = character

func getUserPlayer(id):
	return playerList[id]
