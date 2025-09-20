extends  NodeState

@export var player: Player
@export var animated_sprite_2d: AnimatedSprite2D 
@export var hit_component_collision_shape: CollisionShape2D 

##the function runs at game launch
func _ready() -> void:
	hit_component_collision_shape.disabled = true
	hit_component_collision_shape.position = Vector2(0,0)
	
func _on_process(_delta : float) -> void:
	pass


func _on_physics_process(_delta : float) -> void:
	pass

func _on_next_transitions() -> void:
	if !animated_sprite_2d.is_playing():
		transition.emit("Idle")

func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("watering_back")
		hit_component_collision_shape.position = Vector2(7,0)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("watering_right")
		hit_component_collision_shape.position = Vector2(24,-1)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("watering_front")
		hit_component_collision_shape.position = Vector2(-6,0)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("watering_left")
		hit_component_collision_shape.position = Vector2(-24,0)
	else:
		animated_sprite_2d.play("watering_front")
		hit_component_collision_shape.position = Vector2(-6,0)
		
	hit_component_collision_shape.disabled = false
		
func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
