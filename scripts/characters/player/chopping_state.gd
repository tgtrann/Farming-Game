##the script controls any programming for the player's chopping state
extends  NodeState

#TODO: tree dissappear before the chopping animation finishes

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

##controls player animations and repositions the hit collision position
##depending on player's direction
func _on_enter() -> void:
	if player.player_direction == Vector2.UP:
		animated_sprite_2d.play("chopping_back")
		animated_sprite_2d.position = Vector2(3,-20)
	elif player.player_direction == Vector2.RIGHT:
		animated_sprite_2d.play("chopping_right")
		hit_component_collision_shape.position = Vector2(9,-1)
	elif player.player_direction == Vector2.DOWN:
		animated_sprite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(-4,2)
	elif player.player_direction == Vector2.LEFT:
		animated_sprite_2d.play("chopping_left")
		hit_component_collision_shape.position = Vector2(-9,-1)
	else:
		#ensures that if the player is not pressing any inputs, and only clicks
		#their mouse button, the player will chop from the front
		animated_sprite_2d.play("chopping_front")
		hit_component_collision_shape.position = Vector2(-4,2)
		
	##activates the collision shape when player enters the chopping state
	hit_component_collision_shape.disabled = false
		
##the function states what happens after the player has exited the chopping state
func _on_exit() -> void:
	animated_sprite_2d.stop()
	hit_component_collision_shape.disabled = true
