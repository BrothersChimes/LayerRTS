extends PlayerState

const WALK_SPEED = 50

func _ready():
	animated_sprite.play("walk")

export var attack_distance = 48
export var attack_damage = 60

const base_speed = 200
const walk_anim_speed_base = 1
const run_speed_mult = 2
const attack_time = 0.1 # TODO SHOULD BE 0.5
const fizzle_time = 0.2
const ATTACK_COST = 10 # TODO SHOULD BE 80

var attack_timer = 0
var fizzle_timer = 0

var walk_anim_speed = walk_anim_speed_base
var player_speed = base_speed
var is_facing_left = false

var is_player_near_enemy = false
var is_enemy_left = false

var is_attacking = false
var is_fizzling = false

const max_mana = 100
var mana = 100
const mana_recharge = 50

var health = 100
var max_health = 100
const health_recharge = 1

func _process(delta):
	modulate_bars(delta)
	
	if Input.is_action_just_pressed("attack"):
		if mana >= ATTACK_COST:
			start_attack()
		else: 
			start_fizzle()
	
	if Input.is_action_just_pressed("toggle_build"):
		persistent_state.emit_signal("toggle_build")
			
	if attack_timer <= 0: 
		is_attacking = false
	
	if fizzle_timer <= 0: 
		is_fizzling = false
	
	if is_attacking: 
		attack_timer -= delta
		return
	
	if is_fizzling: 
		fizzle_timer -= delta
		return
		
	walk_actions(delta)

func walk_actions(delta): 
	if Input.is_action_pressed("run") :
		walk_anim_speed = walk_anim_speed_base*run_speed_mult
		player_speed = base_speed*run_speed_mult
	else: 
		walk_anim_speed = walk_anim_speed_base
		player_speed = base_speed
	
	if Input.is_action_pressed("walk_left") and position.x > -480:
		face_left()
		if is_player_near_enemy and is_enemy_left: 
			anim_idle()
			return
		persistent_state.position.x = persistent_state.position.x - delta*player_speed
		anim_walk()
	elif Input.is_action_pressed("walk_right") and position.x < 1400: 
		face_right()
		# print("ISNEAR: " + str(is_player_near_enemy))
		if is_player_near_enemy and not is_enemy_left: 
			anim_idle()
			return
		persistent_state.position.x = persistent_state.position.x + delta*player_speed
		anim_walk()
	else: 
		anim_idle()

func modulate_bars(delta): 
	health = clamp(max_health, 0, health + health_recharge*delta)
	mana = clamp(max_mana, 0, mana + mana_recharge*delta)
	health_bar.set_value(health/max_health*100)
	mana_bar.set_value(mana/max_mana*100)
	var r = range_lerp(health_bar.value, 40, 100, 0.8, 0.2)
	var g = range_lerp(health_bar.value, 40, 100, 0.2, 0.8)
	var styleBox = health_bar.get("custom_styles/fg")
	styleBox.bg_color = Color(r, g, 0.1)

func start_attack(): 
	if not is_attacking:
		is_attacking = true
		persistent_state.emit_signal("player_attacking", attack_damage, is_facing_left)
		mana -= ATTACK_COST
	if attack_timer <= 0: 
		attack_timer = attack_time
		
func start_fizzle(): 
	if not is_fizzling and not is_attacking:
		is_fizzling = true
		mana = clamp(100, 0, mana - 5)
		animated_sprite.play("fizzle")
	if fizzle_timer <= 0: 
		fizzle_timer = fizzle_time

func play_hit_animation(): 
	animated_sprite.play("attack")

func play_miss_animation(): 
	animated_sprite.play("miss")

func anim_walk(): 
	animated_sprite.play("walk")
	animated_sprite.speed_scale = walk_anim_speed
	
func anim_idle(): 
	animated_sprite.play("idle")

func face_left(): 
	is_facing_left = true
	animated_sprite.flip_h = true
	
func face_right(): 
	is_facing_left = false
	animated_sprite.flip_h = false

func near_enemy(is_near, is_left): 
	is_player_near_enemy = is_near
	is_enemy_left = is_left

func _on_PlayerSprite_animation_finished():
	if is_attacking or is_fizzling: 
		animated_sprite.play("idle")
		
func deal_damage(amount): 
	health -= amount
