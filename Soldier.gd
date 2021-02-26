extends Node2D

const cycle_speed = 100
const position_delta = 4 
# var a = 2
var hp = 0
var stamina = 100
var display_name = "display name"
var expected_x_position = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = display_name
	$StaminaLabel.text = str(stamina)
	$HealthLabel.text = str(hp)
	
func _process(delta): 
	# TODO Only do this if you are alive and idle or whatever
	if position.x - expected_x_position > position_delta: 
		position.x -= delta*cycle_speed
	elif expected_x_position - position.x > position_delta:
		position.x += delta*cycle_speed
	else: 
		position.x = expected_x_position
		
func take_hp_damage(hp_damage): 
	hp = hp - hp_damage
	if hp < 0: 
		hp = 0
	$HealthLabel.text = str(hp)

func take_stamina_damage(stamina_damage): 
	stamina -= stamina_damage
	if stamina < 0: 
		stamina = 0
	print("New stamina for " + display_name + ": " + str(stamina))
	$StaminaLabel.text = str(stamina)	


func face_left(): 
	$soldier_sprite.flip_h = true
	
func face_right(): 
	$soldier_sprite.flip_h = false

func set_sprite_attack(): 
	$soldier_sprite.play("attack")

func set_sprite_idle(): 
	$soldier_sprite.play("idle")
	
func set_sprite_damaged(): 
	$soldier_sprite.play("damaged")
	
func set_sprite_defend(): 
	$soldier_sprite.play("defend")

func set_sprite_dead(): 
	$soldier_sprite.play("dead")
	$NameLabel.visible = false
	$StaminaLabel.visible = false
	$HealthLabel.visible = false
	var position_shift = randi()%10-5
	$soldier_sprite.z_index = position_shift-2
	$soldier_sprite.position.y += position_shift

