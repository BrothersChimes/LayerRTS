extends Node2D

const MAX_INT = 9223372036854775807

var barrackses_to_builders_dict = {}
var unbuilt_barrackses = []

func _on_UnitsController_register_units(): 
	var builders = $UnitsController.builders
	for builder in builders: 
		builder.connect("start_building", self, "_on_Builder_start_building")

func _on_BuildingsController_barracks_placed(barracks_builder):
	# Send a builder to start building
	find_closest_nonbusy_builder(barracks_builder)

func find_first_nonbusy_builder(barracks_builder): 
	var builders = $UnitsController.builders
	for builder in builders: 
		if not builder.is_busy(): 
			builder.set_target_building(barracks_builder)
			barrackses_to_builders_dict[barracks_builder] = builder
			return
	unbuilt_barrackses.append(barracks_builder)
	
func find_closest_nonbusy_builder(barracks_builder): 
	var builders = $UnitsController.builders
	var closest_builder = null
	var closest_distance = MAX_INT
	
	for builder in builders: 
		if not builder.is_busy(): 
			var dist = abs(builder.position.x - barracks_builder.position.x)
			if dist < closest_distance: 
				closest_distance = dist
				closest_builder = builder

	if closest_builder == null: 
		unbuilt_barrackses.append(barracks_builder)
		return
	
	closest_builder.set_target_building(barracks_builder)
	barrackses_to_builders_dict[barracks_builder] = closest_builder

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

	build_closest_barracks(builder)

func build_closest_barracks(builder): 
	var closest_barracks
	var closest_distance = MAX_INT
	 
	for unbuilt_barracks in unbuilt_barrackses:
		if abs(unbuilt_barracks.position.x - builder.position.x) < closest_distance:
			closest_barracks = unbuilt_barracks
			closest_distance = abs(unbuilt_barracks.position.x - builder.position.x)
	
	print("I am at: " + str(builder.position.x) +  " and the closest barracks is " + str(closest_barracks.position.x))
	unbuilt_barrackses.remove(unbuilt_barrackses.find(closest_barracks))
	builder.set_target_building(closest_barracks)
	barrackses_to_builders_dict[closest_barracks] = builder
		

func build_first_placed_barracks(builder): 
	var unbuilt_barracks = unbuilt_barrackses.pop_front()
	builder.set_target_building(unbuilt_barracks)
	barrackses_to_builders_dict[unbuilt_barracks] = builder
