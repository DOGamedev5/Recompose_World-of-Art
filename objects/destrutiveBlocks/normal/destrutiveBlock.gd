tool
class_name Block extends KinematicBody2D

onready var particle = preload("res://objects/destrutiveBlocks/particles.tscn")
export var particlesAmount := 3

export var resistence := 1 setget _resistence_set

func _resistence_set(value):
	var frame = clamp(value -1, 0, 1)
	$"%sprite".frame = frame
	resistence = value

func _on_HitboxComponent_HitboxDamaged(damage):
	if damage.damage >= resistence and Network.is_owned(damage.objectId):
		
		destroy()
		Network.sendP2PPacket(-1, {
			"type" : "objectUpdateCall",
			"objectPath" : get_path(),
			"method" : "destroy",
			"value" : []
		}, Steam.P2P_SEND_RELIABLE)

func destroy():
	collision_layer = 0

	var particleInstance = particle.instance()
	
	particleInstance.particlesAmount = particlesAmount
	particleInstance.resistence = resistence
	get_parent().add_child(particleInstance)
	particleInstance.position = position
	
	queue_free()

func _on_VisibilityEnabler2D_screen_entered():
	$CollisionShape2D.disabled = false
	$HitboxComponent/CollisionShape2D.disabled = false

func _on_VisibilityEnabler2D_screen_exited():
	$CollisionShape2D.disabled = true
	$HitboxComponent/CollisionShape2D.disabled = true

