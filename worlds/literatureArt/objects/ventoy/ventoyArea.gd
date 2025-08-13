extends Area2D

export var force := -20

var playerEntered := false

func _ready():
	var _1 = connect("area_entered", self, "_area_entered")
	var _2 = connect("area_exited", self, "_area_exited")

func _physics_process(delta):
	if playerEntered:

		if not Global.player.stateMachine.currentState.name in ["JUMP", "FLY"] and Global.player.onFloor():
			
			Global.player.stateMachine.changeState("FLY")
			Global.player.position += Vector2(force*delta * sin(global_rotation)*8, force*delta * -cos(global_rotation))
		
		Global.player.motion += Vector2(force*delta * sin(global_rotation)*8, force*delta * -cos(global_rotation))

func _area_entered(area):
	if area.is_in_group("player") and Global.player.is_in_group("book"):
		area.get_parent().snapDesatived = true
		area.get_parent().onVentoy = true
		if Network.is_owned(area.get_parent().OwnerID): playerEntered = true

func _area_exited(area):
	if area.is_in_group("player") and Global.player.is_in_group("book"):
		area.get_parent().snapDesatived = false
		area.get_parent().onVentoy = false
		if Network.is_owned(area.get_parent().OwnerID): playerEntered = false
