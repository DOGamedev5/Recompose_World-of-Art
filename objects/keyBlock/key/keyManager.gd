extends Node2D

signal keysCollected

func collect(key):
	key.queue_free()
	
	yield(key, "tree_exited")
	if not get_children():
		emit_signal("keysCollected")
