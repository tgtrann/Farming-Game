##the class represents any collectable objects in the game
extends Area2D

@export var collectable_name: String

func _on_body_entered(body: Node2D) -> void:
	##if the body is the player, then collect the instantiated object 
	if body is Player:
		InventoryManager.add_collectable(collectable_name)
		print("Collected:", collectable_name)
		#erase the collectable object 
		#get_parent - the script is attached to a child component to another node
		get_parent().queue_free()
