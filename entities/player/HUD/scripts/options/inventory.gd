extends Control

var currentScreen := "stats"

onready var screens := {
	"stats" : $stats,
	"items" : $items,
	"map" : $map
}

onready var buttons := {
	"right" : $right,
	"left" : $left
}

func _input(_event):
	if Input.is_action_just_pressed("inventory") and $"../../".currentScreen in ["HUD", "INVENTORY"]:
		visible = not visible
		$"../../HUD".visible = not visible
		
		if visible:
			$"../../".currentScreen = "INVENTORY"
		else:
			$"../../".currentScreen = "HUD"

func _process(_delta):
	match currentScreen:
		"stats":
			buttons["left"].textChanged("< inventory")
			buttons["right"].textChanged("map >")
			
		"items":
			buttons["left"].textChanged("< map")
			buttons["right"].textChanged("stats >")
			
		"map":
			buttons["left"].textChanged("< stats")
			buttons["right"].textChanged("inventory >")

func _on_inventory_visibility_changed():
	get_tree().paused = visible

func _on_left_pressed():
	var pressed := {
		"stats" : "items",
		"items" : "map",
		"map" : "stats"
	}
	
	screens[currentScreen].visible = false
	
	currentScreen = pressed[currentScreen]
	screens[currentScreen].visible = true

func _on_right_pressed():
	var pressed := {
		"stats" : "map",
		"items" : "stats",
		"map" : "items"
	}
	
	screens[currentScreen].visible = false
		
	currentScreen = pressed[currentScreen]
	screens[currentScreen].visible = true
