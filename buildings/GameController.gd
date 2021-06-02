extends Node2D

var enemies = []

func _process(delta): 
	var player_pos_x = $Player.position.x
	
	# TODO make this make more sense.
	var nearness_results = $EnemyController.check_and_project_for_near_enemies(player_pos_x)
	var is_near_enemy = nearness_results[0]
	var is_enemy_left = nearness_results[1]

	$Player.near_enemy(is_near_enemy, is_enemy_left)

func _on_Player_player_attacking(is_facing_left):
	var player_pos_x = $Player.position.x
	var enemy = $EnemyController.nearest_enemy_to(player_pos_x, is_facing_left)
	print("ENEMY: " + str(enemy))
	
	if enemy != null: 
		$EnemyController.kill(enemy)
