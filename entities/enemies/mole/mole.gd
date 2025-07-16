extends EnemyBase

onready var timer := $Timer
onready var cooldown := $AttackCooldown
onready var raycast := $RayCast2D
#onready var stateMachine := $StateMachine

var playerInArea := false

func _ready():
	if stateMachine:
		stateMachine.init(self)

func _physics_process(delta):
	if raycast.is_colliding():
		fliped = !fliped
		
	$RayCast2D.cast_to = Vector2(-32, 0) if fliped else Vector2(32, 0)
	
	if stateMachine:
		stateMachine.processMachine(delta)
	
func attack():
	playerInArea = true


func _on_AreaTrigger_area_exited(area):
	if area.get_parent().is_in_group("player"):
		playerInArea = false
