extends Sprite

export var direction := 0

var motion : Vector2
const gravity := 1800
var scaleAmount := 0.8

func _ready():
	scaleAmount = float(4+(randi() % 8)) / 10

	motion.y = -rand_range(700, 800) 
	motion.x = direction * rand_range(300, 400)

func _physics_process(delta):
	position += motion * delta
	
	motion.y += gravity*delta
	
	if abs(motion.x) > 0:
		motion.x -= 250 * direction * delta
		
	if sign(motion.x) != direction:
		motion.x = 0
	
	if scaleAmount == 0: return
	
	scale *= 1+scaleAmount*delta
	scaleAmount -= 0.2 * delta
	if scaleAmount <0:
		scaleAmount = 0

func _on_Timer_timeout():
	queue_free()
