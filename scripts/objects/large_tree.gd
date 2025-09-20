extends Sprite2D

#TODO: log could get collected before it spawns on map
#TODO: the tree shakes on the first frame of the chopping animation before you actually hit it

@onready var hurt_component: HurtComponent = $HurtComponent
@onready var damage_component: DamageComponent = $DamageComponent

var log_scene = preload("res://scenes/objects/log.tscn")

##the function is activated on game launch
func _ready() -> void:
	hurt_component.hurt.connect(on_hurt)
	damage_component.max_damaged_reached.connect(on_max_damage_reached)
	
##this function applies the damage and shakes the tree using shaders
func on_hurt(hit_damage: int) -> void:
	damage_component.apply_damage(hit_damage)
	material.set_shader_parameter("shake_intensity", 0.5)
	await get_tree().create_timer(1.0).timeout
	material.set_shader_parameter("shake_intensity", 0.0)

##the function removes the object from screen once damage is reached
func on_max_damage_reached() -> void:
	#add the log into the scene on the next frame
	call_deferred("add_log_scene")
	print("max damaged reached")
	#free the tree from memory
	queue_free()	

##the function instatiates a log onto the scene
func add_log_scene() -> void:
	var log_instance = log_scene.instantiate() as Node2D
	log_instance.global_position = global_position
	get_parent().add_child(log_instance)
	
