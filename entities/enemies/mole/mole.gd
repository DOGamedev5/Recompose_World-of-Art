extends EnemyBase

onready var timer := $Timer
onready var cooldown := $AttackCooldown
onready var raycast := $RayCast2D
onready var attackHitbox := $attack/CollisionShape2D
#onready var stateMachine := $StateMachine

var playerInArea := false
export var rotationTarget := 0

func _ready():
	if stateMachine:
		stateMachine.init(self)

func _physics_process(delta):
	if raycast.is_colliding():
		fliped = !fliped
		
	$RayCast2D.cast_to = Vector2(-32, 0) if fliped else Vector2(32, 0)
	
	if stateMachine.currentState.name == "ATTACK":
		sprite.rotation = deg2rad(-rotationTarget) if fliped else deg2rad(rotationTarget)
	else:
		sprite.rotation = 0
	
	if stateMachine:
		stateMachine.processMachine(delta, Network.is_host())
	
func attack():
	playerInArea = true

func _on_AreaTrigger_area_exited(area):
	if area.get_parent().is_in_group("player"):
		playerInArea = false

func _networkUpdate():
	sendPacket({
		"currentState" : stateMachine.currentState.name,
		"position" : global_position,
		"rotation" : global_rotation
	})

func _on_attack_area_entered(area):
	if not (area.is_in_group("player") and area.get_parent().is_in_group("normal")):
		return
		
	var oldPlayer : PlayerBase = Global.player
	var playerPos : Vector2 = oldPlayer.global_position
	Global.player = LoadedObjects.loaded["res://entities/player/powerStates/scover/playerScover.tscn"].instance()
	Global.player.OwnerID = oldPlayer.OwnerID
	
	oldPlayer.queue_free()
	Global.world.add_child(Global.player)
	
	Global.player.global_position = playerPos
