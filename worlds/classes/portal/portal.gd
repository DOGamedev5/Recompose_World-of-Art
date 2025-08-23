extends RoomWarp

onready var sprite := $Portal
onready var time := 0.0
onready var particle := [
	$CPUParticles2D,
	$CPUParticles2D2
]

export var limitsMin := Vector2(-10000000, -10000000)
export var limitsMax := Vector2(10000000, 10000000)

onready var setup := false

func _process(delta):
	sprite.position.x = cos(-time)*15
	sprite.position.y = sin(-time)*15
	
	$Portal/Light2D.energy = 0.3+(1.5+cos(time)) * 0.75
	
	time += delta
	if time >= PI*2:
		time -= PI*2

func createPlayers():
	$Camera2D.current = true
	$Camera2D.limit_left = limitsMin.x
	$Camera2D.limit_top = limitsMin.y
	$Camera2D.limit_right = limitsMax.x
	$Camera2D.limit_bottom = limitsMax.y
	$Tween.interpolate_property(sprite, "scale", Vector2.ZERO, Vector2(1.5, 1.5), 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	particle[0].emitting = true
	particle[1].emitting = true
	

func _on_Area2D_area_entered(area):
	if not Network.is_owned(area.get_parent().OwnerID) or area.get_parent().is_in_group("spectator"): return
	spectator(Network.steamID)
	Network.sendP2PPacket(-1,
		{
			"type" : "objectUpdateCall",
			"objectPath" : get_path(),
			"method" : "spectator",
			"value" : [Network.steamID]
		},
		Steam.NETWORKING_SEND_RELIABLE
		)

func spectator(id):
	Global.world.playerFinished(id)
	
func _on_Tween_tween_completed(_object, _key : String):
	if setup:
		particle[0].emitting = sprite.scale.x > 1
		particle[1].emitting = sprite.scale.x > 1
		return
	
	for member in Network.lobbyMembers:
		var player : PlayerBase = LoadedObjects.loaded["res://entities/player/powerStates/normal/playerNormal.tscn"].instance()
		if Network.steamID == member["ID"]:
			Global.player = player
		
		player.OwnerID = member["ID"]
		player.global_position = global_position
		player.global_position.x += rand_range(-16, 16)
		Global.world.add_child(player)
		
		if Network.is_owned(member["ID"]):
			get_tree().create_timer(0.2).connect("timeout", self, "setupCamera")
			
		player.owner = Global.world

		Players.playerList[member["ID"]].reference = player
		Global.world.finsihedPlayers[member["ID"]] = false
	
	setup = true
	
	$Tween.interpolate_property(sprite, "scale", Vector2(1.5, 1.5), Vector2.ZERO, 0.8, Tween.TRANS_CUBIC, Tween.EASE_IN, 1.8)
	$Tween.start()

func setupCamera():
	Global.player.camera.current = true
	Global.world.isPortalSetup = true

func escapeActivate():
	$Tween.interpolate_property(sprite, "scale", Vector2.ZERO, Vector2(1.5, 1.5), 0.8, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()
	$AnimationPlayer.play("spin")
	
	if $VisibilityEnabler2D.is_on_screen():
		$Area2D/CollisionShape2D.disabled = false
		$attract/CollisionShape2D.disabled = false

func _on_VisibilityEnabler2D_screen_entered():
	$Area2D/CollisionShape2D.disabled = not Global.world.clock
	$AnimationPlayer.play("spin")
	
		
