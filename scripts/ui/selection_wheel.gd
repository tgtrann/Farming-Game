@tool
extends Control
class_name SelectionWheel

const SPRITE_SIZE = Vector2(16, 16)

@export var bkg_color: Color # stores the background color
@export var line_color: Color # stores the color 
@export var hover_color: Color # stores the color once option is hovered

@export var outer_radius: int = 256 # stores the outer circle
@export var inner_radius: int = 64 # stores the inner circle
@export var line_width: int = 4 # stores the thickeness of lines

@export_storage var options: Array[WheelOption] # stores the different options for our selection wheel

var selection: int = 0

@onready var tool_label: Label = $MarginContainer/VBoxContainer/Tool
@onready var desc_label: Label = $MarginContainer/VBoxContainer/Description
@onready var wheel_diameter: Vector2 = Vector2(outer_radius * 2, outer_radius * 2)

func _ready() -> void:
	hide()  # start hidden
	mouse_filter = Control.MOUSE_FILTER_STOP  # capture mouse events	
	
func _get_property_list() -> Array[Dictionary]:
	var result:Array[Dictionary] = []
	result.append(
		{
			name = "Tools",
			type = TYPE_NIL,
			hint_string = "tex_",
			usage = PROPERTY_USAGE_GROUP
		}
	)
	for key:String in DataTypes.Tools:
		result.append(
			{
				name = "tex_" + key,
				type = TYPE_OBJECT, 
				hint = PROPERTY_HINT_RESOURCE_TYPE,
				hint_string = "Texture2D",
				usage = PROPERTY_USAGE_EDITOR
			}
		)

	return result

func _get(property:StringName) -> Variant:
	if not property.begins_with("tex_"):
		return null

	property = property.trim_prefix("tex_")
	if not DataTypes.Tools.has(property):
		return null

	if options.size() != DataTypes.Tools.size():
		options.resize(DataTypes.Tools.size())

	var enum_value:int = DataTypes.Tools[property]
	return options[enum_value]

func _set(property:StringName, value:Variant) -> bool:
	if not property.begins_with("tex_"):
		return false

	property = property.trim_prefix("tex_")
	if not DataTypes.Tools.has(property):
		return false

	if options.size() != DataTypes.Tools.size():
		options.resize(DataTypes.Tools.size())

	var enum_value:int = DataTypes.Tools[property]
	options[enum_value] = value
	return true

func close() -> String:
	hide()
	if selection >= 0 and selection < options.size():
		return options[selection].name
	return ""
	
func _draw() -> void:
	#centers the sprite
	var offset = SPRITE_SIZE / -2
	
	draw_circle(Vector2.ZERO, outer_radius, bkg_color)
	draw_arc(Vector2.ZERO, inner_radius, 0, TAU, 128, line_color, line_width, true)
			
	if len(options) >= 3:
		# draw seperator lines
		for i in range(len(options) - 1):
			# store the radius of the circle
			var rads = TAU * i / (len(options) - 1)
			# store the coordinates of the point of the angle radius
			var point = Vector2.from_angle(rads)
			draw_line(
				point * inner_radius,
				point * outer_radius,
				line_color,
				line_width,
				true
			)
			
		if selection == 0:
			draw_circle(Vector2.ZERO, inner_radius, hover_color)
		
		#create center circle
		draw_texture_rect_region(
			options[0].atlas,
			Rect2(offset, SPRITE_SIZE),
			options[0].region
		)
		
		for i in range(1, len(options)):
			var start_rads = (TAU * (i - 1)) / (len(options) - 1)
			var end_rads = (TAU * i) / (len(options) - 1)
			var mid_rads =  (start_rads + end_rads)/2.0 * -1
			var radius_mid = (inner_radius + outer_radius) / 2
			
			if selection == i:
				#store the coordinates for each arc
				var points_per_arc = 32
				var points_inner = PackedVector2Array()
				var points_outer = PackedVector2Array()
				
				for j in range(points_per_arc + 1):
					var angle = start_rads + j * (end_rads - start_rads) / points_per_arc
					points_inner.append(inner_radius * Vector2.from_angle(TAU-angle))
					points_outer.append(outer_radius * Vector2.from_angle(TAU-angle))
				
				points_outer.reverse()
				draw_polygon(
					points_inner + points_outer,
					PackedColorArray([hover_color])
				)
			
			#calculate the draw position of the icon	
			var draw_pos = radius_mid * Vector2.from_angle(mid_rads) + offset
			
			#draw the texture onto the selection wheel
			draw_texture_rect_region(
				options[i].atlas,
				Rect2(draw_pos, SPRITE_SIZE),
				options[i].region
			)
						
## the function figures out which slice of the the selection wheel the mouse is hovering over
func _process(delta):
	if not visible:
		return

	# safety check for tool scripts
	if tool_label == null:
		return
		
	#store mouse position relative to the current object
	var mouse_pos = get_local_mouse_position()
	#store the mouse radius that measures the distance of the mouse to the center of the circle
	var mouse_radius = mouse_pos.length()
	
	#check which wheel option the mouse is on
	if mouse_radius < inner_radius:
		selection = 0
	else:
		var mouse_rads = fposmod(mouse_pos.angle() * -1, TAU)
		selection = ceil((mouse_rads / TAU) * (len(options) - 1))
	
	# Update center label text
	#if selection >= 0 and selection < options.size():
		#center_label.text = options[selection].display_text
	#else:
		#center_label.text = ""
	if selection == 0:
		tool_label.text = "None"  # or whatever you want for the center
	else:
		tool_label.text = options[selection].name
		
	var option_texts = {
		0: "Pick Tool",
		1: "Chop trees",
		2: "Till the Ground",
		3: "Water the crops",
		4: "Plant for corn",
		5: "Plant for tomato"
	}
	
	desc_label.text = option_texts.get(selection, "")
		
	queue_redraw()
			
func _input(event: InputEvent) -> void:
	# Show wheel when pressing key (example: "open_wheel")
	if event.is_action_pressed("tool_select"):
		selection = 0
		show()

	# Hide wheel when releasing key
	if event.is_action_released("tool_select"):
		hide()

	# Detect click on a slice
	if visible and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		ToolManager.select_tool(selection)
		close()
	
