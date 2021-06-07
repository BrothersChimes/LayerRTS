extends Node2D

var enemies = []

func _process(delta): 
	var player_pos_x = $Player.position.x
	
	# TODO make this make more sense.
	var nearness_results = $EnemyController.check_and_project_for_near_enemies(player_pos_x)
	var is_near_enemy = nearness_results[0]
	var is_enemy_left = nearness_results[1]

	$Player.near_enemy(is_near_enemy, is_enemy_left)

func _on_Player_player_attacking(damage, is_facing_left):
	var player_pos_x = $Player.position.x
	var distance =  $Player.attack_distance
	var enemies = $EnemyController.all_enemies_within(player_pos_x, distance, is_facing_left)
	
	if enemies.empty(): 
		$Player.play_miss_animation()
	else: 
		$Player.play_hit_animation()
	
	for enemy in enemies: 
		if enemy != null: 
			$EnemyController.deal_damage_to(enemy, damage)


func _on_Player_toggle_build():
	$AlliedController/BuildingsController.toggle_build()


func _on_EnemyController_deal_damage(amount):
	$Player.deal_damage(amount)
