extends Timer

@export var audio_stream_player_2D: AudioStreamPlayer2D

#TODO: play sfx when in the area 
func _on_timeout() -> void:
	audio_stream_player_2D.play()
