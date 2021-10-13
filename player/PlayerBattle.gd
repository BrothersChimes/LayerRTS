extends PlayerState

func _ready():
	pass # Replace with function body.

func _on_PlayerSprite_animation_finished():
	pass

func enemy_near_player(): 
	print("Battle: enemy near player")

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
