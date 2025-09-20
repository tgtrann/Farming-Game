class_name HurtComponent
extends Area2D

@export var tool: DataTypes.Tools = DataTypes.Tools.None

signal hurt

func _on_area_entered(area: Area2D) -> void:
	##store the area as a HitComponent and store it in hit_component
	var hit_component = area as HitComponent
	
	#if the player is holding a tool then call the hit_damage value
	if tool == hit_component.current_tool:
		hurt.emit(hit_component.hit_damage)
