 extends Node

enum lobbyStatus {Private, Friends, Public, Invisible}
enum searchDistance {Close, Default, Far, Worldwide}

var lobbyID := -1
var lobbyMembers := []
var steamID := 0
var personaName := ""

const MAX_P2P_PACKETS := 32

enum {
	netSteam,
	netEnet
}
var conectionType := netSteam
var connectionOwner := -1

signal lobbyMatchList(lobbies)
signal enteredLobby()
signal createdLobby()
signal startedGame()
signal worldSelected(world)
signal newMemberJoined(id)
signal memberLeft(id)


func _ready():
	Steam.connect("p2p_session_request", self, "p2p_request")
	Steam.connect("p2p_session_connect_fail", self, "p2p_connect_fail")
	Steam.connect("lobby_created", self, "_lobby_created")
	Steam.connect("lobby_match_list", self, "_lobby_match_list")
	Steam.connect("lobby_joined", self, "_lobby_joined")
	Steam.connect("lobby_chat_update", self, "_lobby_chat_update")
	Steam.connect("join_requested", self, "_lobby_join_request")
	
	steamID = Steam.getSteamID()
	personaName = Steam.getPersonaName()

func _process(_delta):
	readAllP2PPackets()

func get_lobby_menbers():
	lobbyMembers.clear()

	for menberI in range(Steam.getNumLobbyMembers(lobbyID)):
		var ID := Steam.getLobbyMemberByIndex(lobbyID, menberI)
		lobbyMembers.append(
			{
				"ID" : ID,
				"NAME" : Steam.getFriendPersonaName(ID)
			}
		)
		
		Players.addPlayer(ID)

func sendP2PPacket(target : int, packet : Dictionary, sendType : int):
	var channel := 0
	
	var data := PoolByteArray([])
	
	data.append_array(var2bytes(packet))
	
	if target == -1:
		for member in lobbyMembers:
			if member["ID"] != steamID:
				Steam.sendP2PPacket(member["ID"], data, sendType, channel)
	else:
		Steam.sendP2PPacket(target, data, sendType, channel)

func readAllP2PPackets(count := 0):
	if count >= MAX_P2P_PACKETS: return
	
	if Steam.getAvailableP2PPacketSize(0) > 0:
		readP2PPacket()
		readAllP2PPackets(count + 1)

func readP2PPacket():
	var packetSize := Steam.getAvailableP2PPacketSize(0)
	if packetSize > 0:
		var data := Steam.readP2PPacket(packetSize, 0)
		
		var _packet_sender : int = data["remote_steam_id"]
		var packet : Dictionary = bytes2var(data["data"])
		
		match packet["type"]:
			"message": Global.sendMessagge(packet["text"], data["remote_steam_id"])
			"startGame":
				print("a")
				emit_signal("startedGame")
			"selectedWorld":
				emit_signal("worldSelected", packet["world"])
				print(packet["world"])
			"playerUpdate":
				if Players.playerList.has(packet["sender"][0]):
					if Players.playerList[packet["sender"][0]].reference:
						Players.playerList[packet["sender"][0]].reference.receivePacket(packet)
			_:
				print(packet["type"])
			
func p2p_request(steamIDRemote):
	if steamIDRemote == steamID: return
	Steam.acceptP2PSessionWithUser(steamIDRemote)

func p2p_connect_fail(steam_id, session_error):
	if session_error == 0:
		print("WARNING: Session failure with %s: no error given" % steam_id)

	elif session_error == 1:
		print("WARNING: Session failure with %s: target user not running the same game" % steam_id)

	elif session_error == 2:
		print("WARNING: Session failure with %s: local user doesn't own app / game" % steam_id)

	elif session_error == 3:
		print("WARNING: Session failure with %s: target user isn't connected to Steam" % steam_id)

	elif session_error == 4:
		print("WARNING: Session failure with %s: connection timed out" % steam_id)

	elif session_error == 5:
		print("WARNING: Session failure with %s: unused" % steam_id)

	else:
		print("WARNING: Session failure with %s: unknown error %s" % [steam_id, session_error])

func createLobby():
	if lobbyID == -1:
		Steam.createLobby(lobbyStatus.Public, 4)

func findLobbies():
	Steam.addRequestLobbyListDistanceFilter(searchDistance.Worldwide)
	Steam.addRequestLobbyListStringFilter("game", "LastMinuteRepair", Steam.LOBBY_COMPARISON_EQUAL)
	Steam.requestLobbyList()

func joinLobby(LobbyID):
	Steam.joinLobby(LobbyID)

func leaveLobby():
	for menber in lobbyMembers:
		Steam.closeP2PSessionWithUser(menber["ID"])
	
	lobbyMembers.clear()
	
	if lobbyID:
		Steam.leaveLobby(Network.lobbyID)
		Players.clearPlayers()
		lobbyID = -1

func _lobby_created(connect, newLobbyID):
	if connect == 1:
		lobbyID = newLobbyID
		
		Steam.setLobbyData(lobbyID, "name", Network.personaName)
		Steam.setLobbyData(lobbyID, "game", "LastMinuteRepair")
		
		Steam.setLobbyJoinable(lobbyID, true)
		emit_signal("createdLobby")
		get_lobby_menbers()
		Players.addPlayer(steamID)
		
	else:
		print(connect)

func _lobby_joined(LobbyID, _permissions, _locked, response):
	if response == Steam.CHAT_ROOM_ENTER_RESPONSE_SUCCESS:
		lobbyID = LobbyID
		emit_signal("enteredLobby")
		get_lobby_menbers()

func _lobby_match_list(lobbiesAll):
	emit_signal("lobbyMatchList", lobbiesAll)

func _lobby_chat_update(_lobbyID, changedID, makingChangeID, chatState):
	
	var changer := Steam.getFriendPersonaName(makingChangeID)
	var _changed := Steam.getFriendPersonaName(changedID)
	
	match chatState:
		1:
			get_lobby_menbers()
			emit_signal("newMemberJoined", changer)
			
			Global.sendMessagge("{n} has entered the lobby! welcome!".format({"n" : changer})) 
			
		2:
			get_lobby_menbers()
			emit_signal("memberLeft", changer)
			
			Global.sendMessagge("{n} has left the lobby. We'll miss you!!".format({"n" : changer})) 
		
		8:
			get_lobby_menbers()
			emit_signal("memberLeft", changer)
			
			Global.sendMessagge("{n} has been kicked! Maybe you'll learn this time...".format({"n" : changer})) 
		
		16:
			get_lobby_menbers()
			emit_signal("memberLeft", changer)
			
			Global.sendMessagge("{n} has been banned! You are not welcome here!".format({"n" : changer}))
		
		_: Global.sendMessagge("{n} has... did something?".format({"n" : changer}))
	match chatState:
		1: print("{n} has entered the lobby! welcome!".format({"n" : changer})) 
		2: print("{n} has left the lobby. We'll miss you!!".format({"n" : changer})) 
		8: print("{n} has been kicked! Maybe you'll learn this time...".format({"n" : changer})) 
		16: print("{n} has been banned! You are not welcome here!".format({"n" : changer}))
		_: print("{n} has... did something?".format({"n" : changer}))
	
	if chatState in [2, 8, 16]:
		Players.removePlayer(makingChangeID)
	
	get_lobby_menbers()

func _lobby_message():
	pass

func _lobby_data_update(success, LobbyID, menberID, key):
	print("sucess: {success}, lobbyID: {lobbyID}, menberID: {menberID}, key: {key}".format(
		{
			"success" : success, "lobbyID" : LobbyID, "menberID" : menberID, "key" : key
		}
	))

func _lobby_join_request(LobbyID, _friendID):
	joinLobby(LobbyID)

func is_host() -> bool:
	return Steam.getLobbyOwner(Network.lobbyID) == Network.steamID

func is_owned(id) -> bool:
	return id == steamID
