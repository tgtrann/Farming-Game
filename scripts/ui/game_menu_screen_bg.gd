#this script is to freeze any animations, to ensure a still scene
extends Node2D

func _ready() -> void:
	#wait till all assets are loaded on to the screen
	call_deferred("set_scene_process_mode")
	
#function disables all processes, to ensure a still frame
func set_scene_process_mode() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
