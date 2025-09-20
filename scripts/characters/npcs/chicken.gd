extends NonPlayableCharacter

#TODO: need to change direction chicken is facing depending where they are walking
func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
