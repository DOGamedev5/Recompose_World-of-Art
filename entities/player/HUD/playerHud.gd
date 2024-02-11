extends CanvasLayer

onready var healthBarr = $HUD/health/TextureProgress
onready var player = $"../"

func _ready():
	healthBarr.max_value = get_parent().MAXHEALTH
	healthBarr.value = get_parent().health

func setHealthMax(healthMax):
	healthBarr.max_value = healthMax

func setHealth(currentValue):
	healthBarr.value = currentValue
