extends EnemyBase

var projectile := preload("res://entities/enemies/literature/paperbomb/procjectile/projectile.tscn")

const projectsDirection := [
	168.5,
	123.5,
	57.5,
	12.5
]

func _ready():
	stateMachine.init(self)

func _physics_process(delta):
	stateMachine.processMachine(delta)

func explode():
	
	for i in range(4):
#		if i == 2: continue
		var newProject = projectile.instance()
		newProject.rotation_degrees = projectsDirection[i]
		newProject.position = position
		get_parent().add_child(newProject)
	
	
	queue_free()
