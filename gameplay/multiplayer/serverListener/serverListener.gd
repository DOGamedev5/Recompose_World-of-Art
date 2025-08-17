extends Node

signal new_erver
signal remove_server

var cleanTimer := Timer.new()
var socketUdp := PacketPeerUDP.new()
var listenPort := Network.DEFAULT_PORT
var kwownServers := {}

export var cleanupTimer := 3

func _init():
	cleanTimer.wait_time = cleanupTimer
	cleanTimer.one_shot = false
	cleanTimer.autostart = true
	cleanTimer.connect("timeout", self, "cleanUp")
	add_child(cleanTimer)

func _ready():
	kwownServers.clear()
	
	if socketUdp.listen(listenPort) != OK:
		print("LAN: error listening on port {port}".format({"port" : listenPort}))
	else:
		print("LAN: listening on port {port}".format({"port" : listenPort}))
	
func _process(_delta):
	if socketUdp.get_available_packet_count() > 0:
		var serverIP := socketUdp.get_packet_ip()
		var serverPort := socketUdp.get_packet_port()
		var arrayBytes := socketUdp.get_packet()
		
		if serverIP != "" and serverPort > 0:
			if not kwownServers.has(serverIP):
				var message := arrayBytes.get_string_from_ascii()
				var gameInfo : Dictionary = parse_json(message)
				gameInfo.ip = serverIP
				


func cleanUp():
	pass
