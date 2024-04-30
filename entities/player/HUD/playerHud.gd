extends CanvasLayer

onready var healthBarr = $HUD/health/TextureProgress
onready var animationTreeEye = $HUD/eyeIcon/AnimationTree
onready var playbackEye = animationTreeEye["parameters/playback"]
onready var player = $"../"

func _ready():
	healthBarr.max_value = get_parent().MAXHEALTH
	healthBarr.value = get_parent().health

	var _1 = player.connect("damaged", self, "hitted")

func setHealthMax(healthMax):
	healthBarr.max_value = healthMax

func hitted(_direction):

	playbackEye.travel("DAMAGED")
	

func setHealth(currentValue):
	healthBarr.value = currentValue
