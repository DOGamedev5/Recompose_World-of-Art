extends EnemyBase

func _ready():
	stateMachine.init(self)

func _physics_process(delta):
	stateMachine.processMachine(delta)

func explode():
	
	queue_free()
