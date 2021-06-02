extends Node2D

signal building_done(barracks_builder)

const building_tick_time = 0.05
var time_passed_since_last_tick = 0

var total_frames = 0
var building_completion = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite._set_playing(false)
	start_building()

func _process(delta): 
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
	# $AnimatedSprite._set_playing(true)	

func finish_building(): 
	print("FINISH BUILDING")
	emit_signal("building_done", self)
