extends State

onready var timer := $Timer

func enter(_ls):
	timer.start()

func _on_Timer_timeout():
	parent.explode()
