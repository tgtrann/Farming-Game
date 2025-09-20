class_name SaveLevelDataComponent
extends Node

var level_scene_name: String
var save_game_data_path: String = "user://game_data/"
var save_file_name: String = "save_%s_game.tres"
var game_data_resource: SaveGameDataResource

func _ready() -> void:
	add_to_group("save_level_data_component")
	level_scene_name = get_parent().name
	
func save_node_data() -> void:
	#grab all nodes with the save data component and stores them all into a collection
	var nodes = get_tree().get_nodes_in_group("save_data_component")
	
	#create a new instance of the save game data resource and store it into an array
	game_data_resource = SaveGameDataResource.new()
	
	
	if nodes != null:
		for node: SaveDataComponent in nodes:
			if node is SaveDataComponent:
				var save_data_resource: NodeDataResource = node._save_data()
				var save_final_resource = save_data_resource.duplicate()
				game_data_resource.save_data_nodes.append(save_final_resource)
	
##the function handles where the save data gets saved and names the file	
func save_game() -> void:
	#checks if the directory exists, if not make a directory to that path
	if !DirAccess.dir_exists_absolute(save_game_data_path):
		DirAccess.make_dir_absolute(save_game_data_path)
		
	#create the save data file
	var level_save_file_name: String = save_file_name % level_scene_name
		
	#save game
	save_node_data()
		
	var result: int = ResourceSaver.save(game_data_resource, save_game_data_path + level_save_file_name)
	print("Save Result: ", result)
		
		
func load_game() -> void:
	var level_save_file_name: String = save_file_name % level_scene_name
	var save_game_path: String = save_game_data_path + level_save_file_name
	
	#check if the file exists
	if !FileAccess.file_exists(save_game_path):
		return			
		
	#load the game data resources
	game_data_resource = ResourceLoader.load(save_game_path)
	
	if(game_data_resource) == null:
		return
		
	var root_node: Window = get_tree().root
	
	#go through the collection of game data and load the data
	for resource in game_data_resource.save_data_nodes:
		if resource is Resource:
			if resource is NodeDataResource:
				resource._load_data(root_node)
				
		
