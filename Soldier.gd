extends Node2D

signal attack_ready

const cycle_speed = 50
const position_delta = 4 
# var a = 2
var hp = 0
var stamina = 100
var display_name = "display name"
var expected_x_position = 0
var small_offset = 5
var large_offset = 10

var is_facing_left = false
var is_walk_backwards = false
var walk_speed = 0

var intended_anim = "idle"

var is_readying_attack = false

enum MiniPhase {REPOSITION, REACH_LOCATION, DEAD}
var mini_phase = MiniPhase.REPOSITION

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = display_name
	$StaminaLabel.text = str(stamina)
	$HealthLabel.text = str(hp)
	
func _process(delta): 
	if mini_phase == MiniPhase.DEAD:
		return
	# TODO Only do this if you are alive and idle or whatever
	walk_speed = clamp(abs(position.x - expected_x_position)/50+1,1,5)
	if position.x - expected_x_position > position_delta: 
		position.x -= delta*cycle_speed*walk_speed
		mini_phase = MiniPhase.REPOSITION
		is_walk_backwards = not is_facing_left
	elif expected_x_position - position.x > position_delta:
		position.x += delta*cycle_speed*walk_speed
		mini_phase = MiniPhase.REPOSITION
		is_walk_backwards = is_facing_left
	else: 
		position.x = expected_x_position
		mini_phase = MiniPhase.REACH_LOCATION
		if is_readying_attack:
			emit_signal("attack_ready")
			is_readying_attack =false
	
	if mini_phase == MiniPhase.REPOSITION:
		$SoldierSprite.speed_scale = walk_speed
		if hp <= 1: 
			$SoldierSprite.play("walk_hurt")
		else: 
			$SoldierSprite.play("walk")
		if is_walk_backwards:
			$SoldierSprite.flip_h = not is_facing_left
		else: 
			$SoldierSprite.flip_h = is_facing_left
	elif mini_phase == MiniPhase.REACH_LOCATION: 
		$SoldierSprite.speed_scale = 1
		$SoldierSprite.play(intended_anim)
		$SoldierSprite.flip_h = is_facing_left

func ready_for_attack(): 
	is_readying_attack = true

func set_intended_anim(new_intended_anim): 
	intended_anim = new_intended_anim

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
	is_facing_left = true
	$SoldierSprite.flip_h = true
	
func face_right(): 
	is_facing_left = false
	$SoldierSprite.flip_h = false

func set_sprite_attack(): 
	$SoldierSprite.z_index = -1
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")

func set_sprite_attack_move_in(): 
	set_sprite_move_in_offset(large_offset)
	$SoldierSprite.z_index = -1
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")

func set_sprite_idle(): 
	set_sprite_center()
	$SoldierSprite.z_index = 0
	if hp <= 1: 
		set_intended_anim("idle_hurt")
	else: 
		set_intended_anim("idle")
		
func set_sprite_damaged(): 
	$SoldierSprite.z_index = 0
	if hp <= 0: 
		set_sprite_move_in_offset(large_offset)
		set_intended_anim("damaged_hurt")
	else:
		set_sprite_move_in_offset(small_offset)
		set_intended_anim("damaged")
	
func set_sprite_attack_defend(): 
	if is_facing_left: 
		$SoldierSprite.z_index = -2
	else: 
		$SoldierSprite.z_index = 2
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")
	
func set_sprite_defend(): 
	if is_facing_left: 
		$SoldierSprite.z_index = -2
	else: 
		$SoldierSprite.z_index = 2
	set_sprite_move_back_offset(small_offset)
	if hp <= 1: 
		set_intended_anim("defend_hurt")
	else:
		set_intended_anim("defend")

func set_sprite_center(): 
	$SoldierSprite.position.x = 0
	
func set_sprite_move_in_offset(offset): 
	if is_facing_left: 
		$SoldierSprite.position.x = -offset
	else: 
		$SoldierSprite.position.x = offset	

func set_sprite_move_back_offset(offset): 
	if is_facing_left: 
		$SoldierSprite.position.x = offset
	else: 
		$SoldierSprite.position.x = -offset	
	
func set_sprite_dead(): 
	mini_phase = MiniPhase.DEAD
	# set_intended_anim("dead")
	$SoldierSprite.play("dead")
	$NameLabel.visible = false
	$StaminaLabel.visible = false
	$HealthLabel.visible = false
	var dirrandi = randi()
	print("dirrandi: " + str(dirrandi))
	var dir = randi()%2
	print("dir: " + str(dir))
	$SoldierSprite.flip_h = false
	if dir == 0: 
		$SoldierSprite.flip_h = true
	var x_position_shift = randi()%4-2
	var y_position_shift = randi()%10-5
	$SoldierSprite.position.x += x_position_shift
	$SoldierSprite.position.y += y_position_shift
	$SoldierSprite.z_index = y_position_shift-2
