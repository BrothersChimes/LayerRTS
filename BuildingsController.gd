extends Node2D

const ground_level = 162
const barracks_width = 128

var Barracks = preload("buildings/Barracks.tscn")
var BarracksBuilder = preload("buildings/BarracksBuilder.tscn")
var barracks_placer

var placed_barrackses = []
var finished_barrackses = []

const arbitrary_allowed_pos_left = -430
const arbitrary_allowed_pos_right = 1350

func _ready():
	barracks_placer = $BarracksPlacer

func _process(delta):
	if get_is_allowed():
		barracks_placer.set_allowed()
	else: 
		barracks_placer.set_not_allowed()

func _on_BarracksPlacer_place_barracks(x_pos):
	var barracks_builder = BarracksBuilder.instance()
	barracks_builder.position = Vector2(x_pos, ground_level)
	# barracks.z_index = 2
	placed_barrackses.append(barracks_builder)
	add_child(barracks_builder)
	barracks_builder.connect("building_done", self, "_on_BarracksBuilder_building_done")

func _on_BarracksBuilder_building_done(barracks_builder): 
	var x_pos = barracks_builder.position.x
	if placed_barrackses.find(barracks_builder) == -1:
		print("Barracks builder " + str(barracks_builder) + " not found")
	placed_barrackses.remove(placed_barrackses.find(barracks_builder))
	barracks_builder.queue_free()
	var barracks = Barracks.instance()
	barracks.position = Vector2(x_pos, ground_level)
	finished_barrackses.append(barracks)
	add_child(barracks)

func get_is_allowed(): 
	var position_x = barracks_placer.get_position_x()
	if position_x > arbitrary_allowed_pos_left and position_x < arbitrary_allowed_pos_right: 
		if not get_is_barracks_present(position_x):
			return true
	return false

#TODO this will get inefficient eventually, especially since it is called every _process
func get_is_barracks_present(pos): 
	for barracks in placed_barrackses:
		if abs(barracks.position.x - pos) < barracks_width:
			return true
	for barracks in finished_barrackses:
		if abs(barracks.position.x - pos) < barracks_width:
			return true
	return false
