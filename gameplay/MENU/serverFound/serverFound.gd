extends HBoxContainer

onready var serverName := $Name
onready var id := $ID

export var lobbyID := 0

signal enterLobby(lobbyID)

func _ready():
	update()

func update():
	serverName.text = name
	id.text = str(lobbyID)

func _on_enter_pressed():
	emit_signal("enterLobby", lobbyID)
