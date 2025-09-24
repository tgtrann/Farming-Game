extends NonPlayableCharacter

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var chicken_cluck_multiple_sfx: AudioStreamPlayer2D = $ChickenCluckMultipleSFX

var in_range: bool

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

func on_interactable_activated() -> void: 
	chicken_cluck_multiple_sfx.play()
	print(chicken_cluck_multiple_sfx.stream)
	in_range = true
	
func on_interactable_deactivated() -> void:
	chicken_cluck_multiple_sfx.stop()
	in_range = false
