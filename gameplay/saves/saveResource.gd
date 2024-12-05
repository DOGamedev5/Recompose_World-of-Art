class_name SaveGame extends Resource

export var played := false

export var version := "v0.9.5"

export var currentWorld := "sandDesert"
export var worldPosition := Vector2.ZERO
export var player := {
	"player" : "res://entities/player/powerStates/normal/playerNormal.tscn",
	"position" : Vector2(664, -64),
	"playerProperties" : {
		"name" : ""
	}
}
