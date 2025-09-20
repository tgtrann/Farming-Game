class_name FeedComponent
extends Area2D

signal food_received(area: Area2D)

func _on_area_entered(area: Area2D) -> void:
	# When emitted, any listeners (i.e. classes that call 
	# feedcomponent.food_received will call the connecting method.
	food_received.emit(area)
	
	
