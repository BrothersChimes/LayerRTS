extends Node2D

var barrackses_to_builders_dict = {}
var unbuilt_barrackses = []

func _ready():
	pass

func _on_UnitsController_register_units(): 
	var builders = $UnitsController.builders
	for builder in builders: 
		builder.connect("start_building", self, "_on_Builder_start_building")

func _on_BuildingsController_barracks_placed(barracks_builder):
	# Send a builder to start building
	var builders = $UnitsController.builders
	for builder in builders: 
		if not builder.is_busy(): 
			builder.set_target_building(barracks_builder)
			barrackses_to_builders_dict[barracks_builder] = builder
			return
	unbuilt_barrackses.append(barracks_builder)

func _on_Builder_start_building(builder): 
	builder.get_target_building().start_building()
	
func _on_BuildingsController_barracks_done(barracks_builder):
	var builder = barrackses_to_builders_dict[barracks_builder]
	# TODO:  Free builder to build something else
	barrackses_to_builders_dict.erase(barracks_builder)
	barracks_builder.delete_urself() #TODO
	
	if unbuilt_barrackses.empty(): 
		builder.idle()
		return 

	var unbuilt_barracks = unbuilt_barrackses.pop_front()
	builder.set_target_building(unbuilt_barracks)
	barrackses_to_builders_dict[unbuilt_barracks] = builder
		
