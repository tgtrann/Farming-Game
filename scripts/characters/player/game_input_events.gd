class_name GameInputEvents

static var direction: Vector2

##the function controls player movement and faces them
##in the appropriate direction
static func movement_input() -> Vector2:
	if Input.is_action_pressed("walk_left"):
		direction = Vector2.LEFT
	elif Input.is_action_pressed("walk_right"):
		direction = Vector2.RIGHT
	elif Input.is_action_pressed("walk_up"):
		direction = Vector2.UP
	elif Input.is_action_pressed("walk_down"):
		direction = Vector2.DOWN
	else:
		direction = Vector2.ZERO
	return direction

#the function checks if the player is moving
static func is_movement_input() -> bool:
	if direction == Vector2.ZERO:
		return false;
	else:
		return true;
		
#the function stores the flag value when the player performs the action button
static func use_tool() -> bool: 
	var use_tool_value: bool = Input.is_action_just_pressed("action")
	
	return use_tool_value
