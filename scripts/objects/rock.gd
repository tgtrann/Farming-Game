extends Sprite2D

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var stone_scene = preload("res://scenes/objects/stone.tscn")

##the function is activated on game launch
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
#TODO: create a different shader for having the rock erode while it gets hit	
##this function applies the damage and shakes the tree using shaders
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.3)
	await get_tree().create_timer(0.5).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

##the function removes the object from screen once damage is reached
func on_max_damage_reached() -> void:
	#add the log into the scene on the next frame
	call_deferred("add_stone_scene")
	print("max damaged reached")
	#free the tree from memory
	queue_free()	

##the function instatiates a log onto the scene
func add_stone_scene() -> void:
	var stone_instance = stone_scene.instantiate() as Node2D
	stone_instance.global_position = global_position
	get_parent().add_child(stone_instance)
