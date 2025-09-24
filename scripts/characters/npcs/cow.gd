extends NonPlayableCharacter

@onready var interactable_component: InteractableComponent = $InteractableComponent
@onready var cow_moo_sfx: AudioStreamPlayer2D = $CowMooSFX

var in_range: bool

func _ready() -> void:
	walk_cycles = randi_range(min_walk_cycle, max_walk_cycle)
	interactable_component.interactable_activated.connect(on_interactable_activated)
	interactable_component.interactable_deactivated.connect(on_interactable_deactivated)

func on_interactable_activated() -> void:
	cow_moo_sfx.play()
	in_range = true
	
func on_interactable_deactivated() -> void:
	cow_moo_sfx.stop()
	in_range = false
