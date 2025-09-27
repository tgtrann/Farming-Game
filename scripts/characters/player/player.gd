class_name Player
extends CharacterBody2D

@onready var hit_component: HitComponent = $HitComponent

@export var current_tool: DataTypes.Tools = DataTypes.Tools.None

#intialize a variable to store the players direction
var player_direction: Vector2

func _ready() -> void:
	ToolManager.tool_selected.connect(on_tool_selected)
	
func on_tool_selected(tool: DataTypes.Tools) -> void:
	#player equips the tool
	current_tool = tool
	hit_component.current_tool = tool
	#print("Tool: ", tool)
	

	
