##the class that represents the damage applied or received
class_name DamageComponent
extends Node2D

@export var max_damage = 1
@export var current_damage = 0

signal max_damaged_reached

##the function controls the amount of damage that is applied 
func apply_damage(damage: int) -> void:
	##the clamp method ensures that the damage does not exceed the maximum damage allowed
	current_damage = clamp(current_damage + damage, 0, max_damage)
	
	##if the current damage equals the max damage, then emit the signal
	if current_damage == max_damage:
		max_damaged_reached.emit()
