extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var parent = $"../"

var current := false

onready var serverFound := preload("res://gameplay/MENU/serverFound/serverFound.tscn")

onready var saves := $saves
onready var enterUi := $enter
onready var info := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/Label
onready var IPenter := $enter/MarginContainer/findParty/HBoxContainer/IPenter
onready var chat := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/chat
onready var chatSender := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send
onready var lobby := $enter/MarginContainer/lobby
onready var findParty := $enter/MarginContainer/findParty
onready var playerName := $enter/MarginContainer/lobby/playerList/HBoxContainer/playerName
onready var updateNetwork := $updateNetwork
onready var playerList := $enter/MarginContainer/lobby/playerList/playerList
onready var lobbiesList := $enter/MarginContainer/findParty/Panel/VBoxContainer2/lobbies
onready var refleshLobbies := $enter/RefleshLobbies

enum lobbyStatus {Private, Friends, Public, Invisible}
enum searchDistance {Close, Default, Far, Worldwide}

func _ready():
	

	if not Global.cmdargs.connectLobby:
		hide()
		enterUi.hide()
		saves.show()
	else:
		show()
		saves.hide()
		enterUi.show()
		lobby.show()
		findParty.hide()
	
#	info.text = "Your IP: {IP}\nChat:".format({"IP" : Network.IP_address})
	
	playerName.text = Global.steamName
#	var tree := get_tree()
	
#	get_tree().connect("network_peer_connected", self, "_playerConnected")
#	get_tree().connect("network_peer_disconnected", self, "_playerDisconnected")
#	get_tree().connect("connected_to_server", self, "_connected_to_server")
#	get_tree().connect("server_disconnected", self, "_on_logout")
	Steam.connect("lobby_created", self, "_lobby_created")
	Steam.connect("lobby_match_list", self, "_lobby_match_list")
	Steam.connect("lobby_joined", self, "_lobby_joined")
	Steam.connect("lobby_chat_update", self, "_lobby_chat_update")
#	Steam.connect("lobby_message", self, "_lobby_messsage")
#	Steam.connect("lobby_data_update", self, "_lobby_data_update")
	Steam.connect("join_requested", self, "_lobby_join_request")


func enter():
	for child in $saves/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.grab_focus()
			return
	
	$saves/VBoxContainer/HBoxContainer/contract.grab_focus()
	$saves/VBoxContainer/HBoxContainer/contract.pressed = true
	parent.current = self

func _on_exit_pressed():
	parent.transition(initial, [self, options])

func _on_createLobby_pressed():
	saves.hide()
	enterUi.show()
	lobby.show()
	findParty.hide()
	
	_create_lobby()
#	Network.createServer()
#	Players.addPlayer(get_tree().get_network_unique_id())
	
#	updateNetwork.start()
#	get_tree().root.set_disable_input(true)
#	for child in $saves/VBoxContainer/HBoxContainer.get_children():
#		if child.pressed:
#			child.confirmed()
#			return

func _on_erase_pressed():
	for child in $saves/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.deleted()
			return

func enterServer():
	saves.hide()
	enterUi.show()
	lobby.hide()
	findParty.show()
	
	Steam.addRequestLobbyListDistanceFilter(searchDistance.Worldwide)
	Steam.requestLobbyList()
	refleshLobbies.start()

func _on_enter_pressed():
	if IPenter.text:
		_join_lobby(int(IPenter.text))
#
#		Network.IP_address = IPenter.text
#		var error := Network.enterServer()
#		if error: return
#
#		Players.addPlayer(get_tree().get_network_unique_id())
	
		updateNetwork.start()
		lobby.show()
		findParty.hide()


func _on_send_pressed(_text := ""):
#	if text:
#		Global.sendMessagge(text, get_tree().get_network_unique_id())
#		Global.rpc_unreliable("sendMessagge", text, get_tree().get_network_unique_id())
		
#	elif $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text:
#		chat.text += $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text + "\n"
		
	$enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text = ""

func _playerConnected(id):
	Players.addPlayer(id)
	Global.sendMessagge("{id} just entered!\n".format({"id" : Players.getPlayerName(id)}))
	
	updateNetwork.start()

func _playerDisconnected(id):
	Global.sendMessagge("good bye [color=yellow]{id}[/color], we'll miss you!\n".format({"id" : Players.getPlayerName(id)}))
	Players.removePlayer(id)

func _connected_to_server():
	updateNetwork.start()

func _on_logout():
	updateNetwork.stop()
	lobby.hide()
	findParty.show()
	Players.clearPlayers()
	Global.lobbyMenbers.clear()
	
	if Global.lobbyID:
		Steam.leaveLobby(Global.lobbyID)
		Global.lobbyID = 0

func _on_updateNetwork_timeout():
	var playersNames := {}
	playerList.text = ""

	for player in Global.lobbyMenbers:

		playerList.text += player["NAME"].replace("[", "[lb]") + "\n"
		playersNames[player] = player["NAME"].replace("[", "[lb]")
	
	chat.bbcode_text = ""
	for text in Global.chat:
		chat.bbcode_text += text.format(playersNames)

func _on_RefleshLobbies_timeout():
	Steam.requestLobbyList()

func _on_SpinBox_value_changed(_value):
	Steam.requestLobbyList()
	refleshLobbies.start()

func _on_exitFindLobby_pressed():
	saves.show()
	enterUi.hide()
	
	refleshLobbies.stop()

#######################
### Steam functions ###
#######################
func _create_lobby():
	if not Global.lobbyID:
		Steam.createLobby(lobbyStatus.Public, 4)

func _join_lobby(lobbyID):
#	if not Steam.getLobbyData(lobbyID, "game") == "LastMinuteRepair": return
	
	Steam.joinLobby(lobbyID)

func _get_lobby_menbers():
	Global.lobbyMenbers.clear()
	
	for men in range(Steam.getNumLobbyMembers(Global.lobbyID)):
		var ID := Steam.getLobbyMemberByIndex(Global.lobbyID, men)
		var NAME := Steam.getFriendPersonaName(ID)
		Global.lobbyMenbers.append({"ID" : ID, "NAME" : NAME})
		print(NAME)
		
#####################
### Steam signals ###
#####################
func _lobby_created(connect, lobbyID):
	if connect == 1:
		Global.lobbyID = lobbyID
		print(lobbyID)
		$enter/MarginContainer/lobby/ColorRect/VBoxContainer/Label.text = str(Global.lobbyID)		
		
		Steam.setLobbyData(lobbyID, "name", Global.steamName)
		Steam.setLobbyData(lobbyID, "game", "LastMinuteRepair")
		
		updateNetwork.start()
		
		
	else:
		print(connect)

func _lobby_joined(lobbyID, _permissions, _locked, _response):
	Global.lobbyID = lobbyID
	
	updateNetwork.start()
	lobby.show()
	findParty.hide()
	
	_get_lobby_menbers()
	
	updateNetwork.start()

func _lobby_match_list(lobbies):
	for child in lobbiesList.get_children():
		child.queue_free()
		child.name += "@OLD@"
		
	var spinBox := $enter/MarginContainer/findParty/HBoxContainer/SpinBox
	var MAXPAGE := 4.0
	spinBox.max_value = ceil(float(lobbies.size()) / MAXPAGE)
	
	var i = 1
	for lobbyFoundID in range((spinBox.value-1)*MAXPAGE, lobbies.size()):
		var lobbyFound : int = lobbies[lobbyFoundID]
		
#		if Steam.getLobbyData(lobbyFound, "game") != "LastMinuteRepair":
#			i -= 1
#			continue
		
		var instance := serverFound.instance()
		instance.lobbyID = lobbyFound
		var lobbyName := Steam.getLobbyData(lobbyFound, "name")
		instance.name = lobbyName if lobbyName else "no name found" + str(lobbyFoundID)
		lobbiesList.add_child(instance)
		instance.connect("enterLobby", self, "_join_lobby")
		i += 1

		if i >= MAXPAGE+1: break

func _lobby_chat_update(_lobbyID, _changedID, makingChangeID, chatState):
	
	var changer := Steam.getFriendPersonaName(makingChangeID)
#	var changed := Steam.getFriendPersonaName(changedID)
	
#	match chatState:
#		1: Global.sendMessagge("{n} has entered the lobby! welcome!".format({"n" : changer})) 
#		2: Global.sendMessagge("{n} has left the lobby. We'll miss you!!".format({"n" : changer})) 
#		8: Global.sendMessagge("{n} has been kicked! Maybe you'll learn this time...".format({"n" : changer})) 
#		16: Global.sendMessagge("{n} has been banned! You are not welcome here!".format({"n" : changer}))
#		_: Global.sendMessagge("{n} has... did something?".format({"n" : changer}))
	match chatState:
		1: print("{n} has entered the lobby! welcome!".format({"n" : changer})) 
		2: print("{n} has left the lobby. We'll miss you!!".format({"n" : changer})) 
		8: print("{n} has been kicked! Maybe you'll learn this time...".format({"n" : changer})) 
		16: print("{n} has been banned! You are not welcome here!".format({"n" : changer}))
		_: print("{n} has... did something?".format({"n" : changer}))
	
	_get_lobby_menbers()

func _lobby_message():
	pass

func _lobby_data_update(success, lobbyID, menberID, key):
	print("sucess: {success}, lobbyID: {lobbyID}, menberID: {menberID}, key: {key}".format(
		{
			"success" : success, "lobbyID" : lobbyID, "menberID" : menberID, "key" : key
		}
	))

func _lobby_join_request(lobbyID, _friendID):
	_join_lobby(lobbyID)

func _exit_tree():
	FileSystemHandler.saveDataResource(Global.optionsSavePath, Global.options)
	Global.options.playerName = playerName.text

