extends Node

var allow_save_game: bool

##the function handles the input to save the game
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("save_game"):
		save_game()
		
##the function handles what happens when the user saves the game
func save_game() -> void:
	#stores the save data into a variable
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	#take the stored data and save the game
	if save_level_data_component != null:
		save_level_data_component.save_game()
	
##the function loads the game	
func load_game() -> void:
	await get_tree().process_frame
	
	var save_level_data_component: SaveLevelDataComponent = get_tree().get_first_node_in_group("save_level_data_component")
	
	if save_level_data_component != null:
		save_level_data_component.load_game()
		
