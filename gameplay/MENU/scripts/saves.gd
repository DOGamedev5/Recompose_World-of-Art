extends Control

onready var options = $"../options"
onready var initial = $"../initial"
onready var parent = $"../"

var current := false

onready var serverFound := preload("res://gameplay/MENU/serverFound/serverFound.tscn")
onready var worldSelect := preload("res://worlds/worldSelect/WaitingRoom.tscn")

onready var saves := $saves
onready var enterUi := $enter
onready var info := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/Label
onready var IPenter := $enter/MarginContainer/findParty/HBoxContainer/IPenter
onready var chat := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/chat
onready var chatSender := $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send
onready var lobby := $enter/MarginContainer/lobby
onready var findParty := $enter/MarginContainer/findParty
onready var updateNetwork := $updateNetwork
onready var playerList := $enter/MarginContainer/lobby/info/a/playerList/list
onready var lobbiesList := $enter/MarginContainer/findParty/Panel/VBoxContainer2/lobbies
onready var refleshLobbies := $enter/RefleshLobbies
onready var start := $enter/MarginContainer/lobby/info/buttons/Start


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
	
	
#	var tree := get_tree()
	
	Steam.connect("lobby_message", self, "_lobby_messsage")
#	Steam.connect("lobby_data_update", self, "_lobby_data_update")
	Steam.connect("join_requested", self, "_lobby_join_request")
	Network.connect("lobbyMatchList", self, "_lobby_match_list")
	Network.connect("enteredLobby", self, "_lobby_joined")
	Network.connect("createdLobby", self, "_lobby_created")
	Network.connect("startedGame", self, "loadWorldSelect")
	Global.connect("chatUpdated", self, "_on_updateNetwork_timeout")

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
	start.grab_focus()
	
	Network.createLobby()

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
	$enter/MarginContainer/findParty/HBoxContainer/enter.grab_focus()
	
	Network.findLobbies()
	refleshLobbies.start()

func _on_enter_pressed():
	if IPenter.text:
		_join_lobby(int(IPenter.text))
	
		updateNetwork.start()
		lobby.show()
		findParty.hide()


func _on_send_pressed(text := ""):
	if text:
		Network.sendP2PPacket(-1, {"type" : "message", "text" : text}, 2)
		Global.sendMessagge(text, Network.steamID)

	elif $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text:
		chat.text += $enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text + "\n"
		
	$enter/MarginContainer/lobby/ColorRect/VBoxContainer/send.text = ""

func _connected_to_server():
	updateNetwork.start()

func _on_logout():
	updateNetwork.stop()
	lobby.hide()
	findParty.show()
	Players.clearPlayers()
	Network.leaveLobby()
	
	$enter/MarginContainer/lobby/info/buttons/Start.disabled = true
	chat.text = ""
	Global.chat.clear()
	
func _on_updateNetwork_timeout():
	var playersNames := {}
	playerList.text = ""

	for player in Network.lobbyMembers:
		var pName : String = player["NAME"].replace("[", "[lb]")
		if player["ID"] == Steam.getLobbyOwner(Network.lobbyID):
			pName += "(Host)"
		if Network.is_owned(player["ID"]):
			pName += " <- YOU"

		playerList.text += pName + "\n"
		playersNames[player["ID"]] = player["NAME"].replace("[", "[lb]")
	
	chat.bbcode_text = ""
	for text in Global.chat:
		chat.bbcode_text += text.format(playersNames)
	
		
func _on_RefleshLobbies_timeout(): Network.findLobbies()

func _on_SpinBox_value_changed(_value):
	Network.findLobbies()
	refleshLobbies.start()

func _on_exitFindLobby_pressed():
	saves.show()
	enterUi.hide()
	
	refleshLobbies.stop()

#######################
### Steam functions ###
#######################
func _create_lobby():
	Network.createLobby()

func _join_lobby(lobbyID):
	Network.joinLobby(lobbyID)
		
#####################
### Steam signals ###
#####################
	
func _lobby_joined():
	updateNetwork.start()
	lobby.show()
	findParty.hide()
	
	start.visible = Network.is_host()

	updateNetwork.start()

func _lobby_created():
	$enter/MarginContainer/lobby/info/buttons/Start.disabled = false

func _lobby_match_list(lobbies):
	for child in lobbiesList.get_children():
		child.queue_free()
		child.name += "@OLD@"
		
	var spinBox := $enter/MarginContainer/findParty/HBoxContainer/SpinBox
	var MAXPAGE := 4.0
	spinBox.max_value = ceil(float(lobbies.size()) / MAXPAGE)
	
	
	for lobbyFoundID in range((spinBox.value-1)*MAXPAGE, lobbies.size()):
		var lobbyFound : int = lobbies[lobbyFoundID]
		
		var instance := serverFound.instance()
		instance.lobbyID = lobbyFound
		var lobbyName := Steam.getLobbyData(lobbyFound, "name")
		instance.name = lobbyName if lobbyName else "no name found" + str(lobbyFoundID)
		lobbiesList.add_child(instance)
		instance.connect("enterLobby", self, "_join_lobby")

func _lobby_message():
	$enter/MarginContainer/lobby/playerList/HBoxContainer2/Start.visible = Network.is_host()

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
	Global.options.playerName = Network.personaName

func loadWorldSelect(savePath := ""):
	if Network.is_host():
		FileSystemHandler.loadGameData(savePath)
	
	print("B")

	get_tree().change_scene_to(worldSelect)

func _on_Start_pressed():
	get_tree().root.set_disable_input(true)
	if not Network.is_host():
		return
	for child in $saves/VBoxContainer/HBoxContainer.get_children():
		if child.pressed:
			child.confirmed()
			
			return
