extends Node2D

export var attack_distance = 44

const base_speed = 200
const walk_anim_speed_base = 1
const run_speed_mult = 2
const attack_time = 0.5

var attack_timer = 0

var walk_anim_speed = walk_anim_speed_base
var player_speed = base_speed
var is_facing_left = false

var is_player_near_enemy = false
var is_enemy_left = false

var is_attacking = false

signal player_attacking(is_left)
signal toggle_build()

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):	
	if Input.is_action_pressed("attack"):
		start_attack()
	
	if Input.is_action_just_pressed("toggle_build"):
		emit_signal("toggle_build")
			
	if attack_timer <= 0: 
		is_attacking = false
	
	if is_attacking: 
		attack_timer -= delta
		return
	
	#### 

	if Input.is_action_pressed("run") :
		walk_anim_speed = walk_anim_speed_base*run_speed_mult
		player_speed = base_speed*run_speed_mult
	else: 
		walk_anim_speed = walk_anim_speed_base
		player_speed = base_speed
	
	if Input.is_action_pressed("walk_left") and position.x > -480:
		if is_player_near_enemy and is_enemy_left: 
			anim_idle()
			return
		position.x = position.x - delta*player_speed
		face_left()
		anim_walk()
	elif Input.is_action_pressed("walk_right") and position.x < 1400: 
		# print("ISNEAR: " + str(is_player_near_enemy))
		if is_player_near_enemy and not is_enemy_left: 
			anim_idle()
			return
		position.x = position.x + delta*player_speed
		face_right()
		anim_walk()
	else: 
		anim_idle()

func start_attack(): 
	if not is_attacking:
		is_attacking = true
		$PlayerSprite.play("attack")
		emit_signal("player_attacking", is_facing_left)
	if attack_timer <= 0: 
		attack_timer = attack_time

func anim_walk(): 
	$PlayerSprite.play("walk")
	$PlayerSprite.speed_scale = walk_anim_speed
	
func anim_idle(): 
	$PlayerSprite.play("idle")

func face_left(): 
	is_facing_left = true
	$PlayerSprite.flip_h = true
	
func face_right(): 
	is_facing_left = false
	$PlayerSprite.flip_h = false

func near_enemy(is_near, is_left): 
	is_player_near_enemy = is_near
	is_enemy_left = is_left


func _on_PlayerSprite_animation_finished():
	if is_attacking: 
		$PlayerSprite.play("idle")
