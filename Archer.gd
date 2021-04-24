extends Node2D

signal attack_ready(soldier)

const SoldierType = preload("SoldierType.gd").SoldierType

const cycle_speed = 50
const position_delta = 4 
# var a = 2
var soldier_type = SoldierType.RANGED
var hp = 0
var stamina = 100
var order_number = 0
var display_name = "display name"
var expected_x_position = 0
var expected_x_position_march = 0
var small_offset = 5
var large_offset = 10

var is_facing_left = false
var is_marching_left = false
var is_walk_backwards = false
var walk_speed = 0

var intended_anim = "idle"

var is_readying_attack = false

enum Phase {COMBAT, MARCH, DEAD} 
var phase = Phase.MARCH

var is_march_reach = false

enum MiniPhase {REPOSITION, REACH_LOCATION}
var mini_phase = MiniPhase.REPOSITION

# Called when the node enters the scene tree for the first time.
func _ready():
	$NameLabel.text = display_name
	$StaminaLabel.text = str(stamina)
	$HealthLabel.text = str(hp)
	
func _process(delta): 
	if phase == Phase.DEAD:
		return
		
	if phase == Phase.MARCH: 
		process_march(delta)
		return

	if phase == Phase.COMBAT:
		process_combat(delta)

func process_march(delta): 
	walk_speed = clamp(abs(position.x - expected_x_position_march)/75+1,2,4)
	if position.x - expected_x_position_march > position_delta: 
		position.x -= delta*cycle_speed*walk_speed
		reposition()
		is_walk_backwards = not is_facing_left
	elif expected_x_position_march - position.x > position_delta:
		position.x += delta*cycle_speed*walk_speed
		reposition()
		is_walk_backwards = is_facing_left
	else: 
		position.x = expected_x_position_march
		mini_phase = MiniPhase.REACH_LOCATION

	if mini_phase == MiniPhase.REPOSITION:
		$ArcherSprite.speed_scale = walk_speed
		if hp <= 1: 
			$ArcherSprite.play("walk_hurt")
		else: 
			$ArcherSprite.play("walk")
		if is_walk_backwards:
			$ArcherSprite.flip_h = not is_facing_left
		else: 
			$ArcherSprite.flip_h = is_facing_left
	elif mini_phase == MiniPhase.REACH_LOCATION:
		$ArcherSprite.flip_h = is_marching_left
		if is_march_reach: 
			if hp <= 1: 
				$ArcherSprite.play("idle_hurt")
			else: 
				$ArcherSprite.play("idle")
		else: 
			$ArcherSprite.speed_scale = 2
			if hp <= 1: 
				$ArcherSprite.play("walk_hurt")
			else: 
				$ArcherSprite.play("walk")

	
func process_combat(delta): 
	walk_speed = clamp(abs(position.x - expected_x_position)/75+1,2,4)
	if position.x - expected_x_position > position_delta: 
		position.x -= delta*cycle_speed*walk_speed
		reposition()
		is_walk_backwards = not is_facing_left
	elif expected_x_position - position.x > position_delta:
		position.x += delta*cycle_speed*walk_speed
		reposition()
		is_walk_backwards = is_facing_left
	else: 
		position.x = expected_x_position
		mini_phase = MiniPhase.REACH_LOCATION
		if is_readying_attack:
			emit_signal("attack_ready", self)
			is_readying_attack =false
	
	if mini_phase == MiniPhase.REPOSITION:
		$ArcherSprite.speed_scale = walk_speed
		if hp <= 1: 
			$ArcherSprite.play("walk_hurt")
		else: 
			$ArcherSprite.play("walk")
		if is_walk_backwards:
			$ArcherSprite.flip_h = not is_facing_left
		else: 
			$ArcherSprite.flip_h = is_facing_left
	elif mini_phase == MiniPhase.REACH_LOCATION: 
		$ArcherSprite.speed_scale = 1
		$ArcherSprite.play(intended_anim)
		$ArcherSprite.flip_h = is_facing_left

func start_combat(): 
	phase = Phase.COMBAT

func end_combat(): 
	phase = Phase.MARCH

func stopped_at(x_position, is_marching_left_): 
	$ArcherSprite.speed_scale = 2
	if hp <= 1: 
		$ArcherSprite.play("walk_hurt")
	else: 
		$ArcherSprite.play("walk")
	# position.x = x_position
	is_march_reach = true
	expected_x_position_march = x_position
	is_marching_left = is_marching_left_

func marched_to(x_position, is_marching_left_): 
	$ArcherSprite.speed_scale = 2
	if hp <= 1: 
		$ArcherSprite.play("walk_hurt")
	else: 
		$ArcherSprite.play("walk")
	# position.x = x_position
	is_march_reach = false
	expected_x_position_march = x_position
	is_marching_left = is_marching_left_
			
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
	$StaminaLabel.text = str(stamina)	

func face_left(): 
	is_facing_left = true
	$ArcherSprite.flip_h = true
	
func face_right(): 
	is_facing_left = false
	$ArcherSprite.flip_h = false

func set_sprite_attack(): 
	$ArcherSprite.z_index = -1
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")

func set_sprite_attack_move_in(): 
	set_sprite_move_in_offset(large_offset)
	$ArcherSprite.z_index = -1
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")

func set_sprite_idle(): 
	set_sprite_center()
	$ArcherSprite.z_index = 0
	if hp <= 1: 
		set_intended_anim("idle_hurt")
	else: 
		set_intended_anim("idle")
		
func set_sprite_damaged(): 
	$ArcherSprite.z_index = 0
	if hp <= 0: 
		set_sprite_move_in_offset(large_offset)
		set_intended_anim("damaged_hurt")
	else:
		set_sprite_move_in_offset(small_offset)
		set_intended_anim("damaged")
	
func set_sprite_attack_defend(): 
	if is_facing_left: 
		$ArcherSprite.z_index = -2
	else: 
		$ArcherSprite.z_index = 2
	if hp <= 1: 
		set_intended_anim("attack_hurt")
	else:
		set_intended_anim("attack")
	
func set_sprite_defend(): 
	if is_facing_left: 
		$ArcherSprite.z_index = -2
	else: 
		$ArcherSprite.z_index = 2
	set_sprite_move_back_offset(small_offset)
	if hp <= 1: 
		set_intended_anim("defend_hurt")
	else:
		set_intended_anim("defend")

func set_sprite_center(): 
	$ArcherSprite.position.x = 0
	
func set_sprite_move_in_offset(offset): 
	if is_facing_left: 
		$ArcherSprite.position.x = -offset
	else: 
		$ArcherSprite.position.x = offset	

func set_sprite_move_back_offset(offset): 
	if is_facing_left: 
		$ArcherSprite.position.x = offset
	else: 
		$ArcherSprite.position.x = -offset	
	
func set_sprite_dead(): 
	phase = Phase.DEAD
	# set_intended_anim("dead")
	$ArcherSprite.play("dead")
	$NameLabel.visible = false
	$StaminaLabel.visible = false
	$HealthLabel.visible = false
	var dirrandi = randi()
	var dir = randi()%2
	$ArcherSprite.flip_h = false
	if dir == 0: 
		$ArcherSprite.flip_h = true
	var x_position_shift = randi()%4-2
	var y_position_shift = randi()%10-5
	$ArcherSprite.position.x += x_position_shift
	$ArcherSprite.position.y += y_position_shift
	$ArcherSprite.z_index = y_position_shift-2

func reposition(): 
	mini_phase = MiniPhase.REPOSITION
