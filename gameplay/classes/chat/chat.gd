extends PanelContainer

onready var chat := $margin/vbox/text
onready var chatSender := $margin/vbox/hbox/send
export var canvasLayerPath : NodePath
onready var canvasLayer = get_node_or_null(canvasLayerPath)

#func _ready():
#	Global.connect("chatUpdated", self, "_chat_updated")

func _chat_updated():
	var playersNames := {}

	for player in Network.lobbyMembers:
		playersNames[player["ID"]] = player["NAME"].replace("[", "[lb]")
	
#	chat.bbcode_text = ""

	var newChat := ""
	for text in Global.chat:
		newChat += text.format(playersNames)
	
	if newChat != chat.bbcode_text:
		chat.bbcode_text = newChat
		

func _input(event):
	if event.is_action_pressed("chat") and not $margin/vbox/hbox/send.has_focus():
		visible = !visible
		if canvasLayer:
			canvasLayer.visible = visible
		if visible:
			$margin/vbox/hbox/send.grab_focus()
			Global.inputEnabled = false
		else:
			$margin/vbox/hbox/send.release_focus()
			Global.inputEnabled = true

func _on_send_pressed(_text := ""):
	var textToSend : String = chatSender.text
	if not textToSend: return
	
	Network.sendP2PPacket(-1, {"type" : "message", "text" : textToSend}, 2)
	Global.sendMessagge(textToSend, Network.steamID)
	
	chatSender.text = ""

func _on_update_timeout(): 
	_chat_updated()
