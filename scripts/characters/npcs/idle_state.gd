extends NodeState

@export var character: CharacterBody2D
@export var animated_sprite_2d: AnimatedSprite2D
@export var idle_state_time_interval: float = 5.0

@onready var idle_state_timer: Timer = Timer.new()

#a variable to set the idle timeout state to false
var idle_state_timeout: bool = false;

##the function gets invoked at game launch
func _ready() -> void:
	idle_state_timer.wait_time = idle_state_time_interval
	idle_state_timer.timeout.connect(on_idle_state_timeout)
	add_child(idle_state_timer)	 #add the timer as a child in our node
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass


func _on_next_transitions() -> void:
	#checks if the idle state has timed out then move into the walk state
	if idle_state_timeout:
		transition.emit("Walk")

#the method places the animated sprite(npc) on idle 
func _on_enter() -> void:
	animated_sprite_2d.play("idle")
	
	#flag the idle state timeout to be false and start the timer
	idle_state_timeout = false
	idle_state_timer.start()
	
	
func _on_exit() -> void:
	animated_sprite_2d.stop()
	idle_state_timer.stop()

func on_idle_state_timeout() -> void:
	#sets the idle timeout state to true
	idle_state_timeout = true;
