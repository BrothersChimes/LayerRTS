extends Node2D

signal building_done(barracks_builder)

const building_tick_time = 0.05
var time_passed_since_last_tick = 0

var total_frames = 0
var building_completion = 0
var is_building = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite._set_playing(false)

func _process(delta): 
	if is_building: 
		process_building(delta)

func process_building(delta): 
	time_passed_since_last_tick += delta
	if time_passed_since_last_tick > building_tick_time: 
		building_completion += 1
		if building_completion >= 100: 
			finish_building()
		time_passed_since_last_tick -= building_tick_time
		
		$AnimatedSprite.set_frame(int(floor(building_completion/100.0 * total_frames)))
		$CompletionLabel.set_text(str(building_completion))
		
func start_building(): 
	$AnimatedSprite.set_animation("building")
	total_frames = $AnimatedSprite.get_sprite_frames().get_frame_count("building")
	$CompletionLabel.visible = true
	is_building = true
	
func pause_building(): 
	is_building = false

func finish_building(): 
	emit_signal("building_done", self)

# TODO
func delete_urself(): 
	queue_free()
