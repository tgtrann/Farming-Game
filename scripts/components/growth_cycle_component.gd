class_name GrowthCycleComponent
extends Node

@export var current_growth_state: DataTypes.GrowthStates = DataTypes.GrowthStates.Germination
# Assumes that all crops are harvestable at day 7
@export_range(5, 365) var days_until_harvest: int = 7

signal crop_maturity
signal crop_harvesting

var is_watered: bool
var starting_day: int
var current_day: int

func _ready() -> void:
	DayAndNightCycleManager.time_tick_day.connect(on_time_tick_day)

func on_time_tick_day(day: int) -> void:
	if is_watered:
		if starting_day == 0:
			starting_day = day
		
		#invoke the growth state, once the crops has been watered	
		growth_states(starting_day, day)
		harvest_state(starting_day, day)
	
##the function calculates the growth days that have passed and modifies the 
##crop's sprite as it matures
func growth_states(starting_day: int, current_day: int):
#	#already in matured state, no need to do anything else, just return
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		return
		
	var num_states = 5
	
	#calculate the growth days passed and store the current index of the growth state
	var growth_days_passed = (current_day - starting_day) % num_states
	var state_index = growth_days_passed % num_states + 1

	#store the index of the state
	current_growth_state = state_index
	
	#store the growth state into a variable called name
	var name = DataTypes.GrowthStates.keys()[current_growth_state]
	print("Current growth state:", name, "State index:", state_index)
	
	#checks if the current growth state reached maturity state then have the listener
	#emit a signal
	if current_growth_state == DataTypes.GrowthStates.Maturity:
		crop_maturity.emit()
		
##the function controls the harvest state
func harvest_state(starting_day: int, current_day: int) -> void:
#	# already in harvesting state, no need to do anything else, exit...
	if current_growth_state == DataTypes.GrowthStates.Harvesting:
		return
	
	# check the number of days that have passed since first watering
	var days_passed = (current_day - starting_day)
	
	# check if the number of days passed since first watering has already reached
	# the day count when the crop can be harvested (default 7). 
	# Subtract by 1 because we start day 1 instead of day 0
	if days_passed == days_until_harvest -1:
		# Crop is ready for harvesting, set growth state appropriately
		current_growth_state = DataTypes.GrowthStates.Harvesting
		crop_harvesting.emit()

##the function returns the current growth state
func get_current_growth_state() -> DataTypes.GrowthStates:
	return current_growth_state
