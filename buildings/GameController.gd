extends Node2D

var enemies = []

func _process(delta): 
	var player_x_pos = $Player.position.x
	
	# TODO make this make more sense.
	var nearness_results = $EnemyController.check_and_project_for_near_enemies(player_x_pos)
	var is_near_enemy = nearness_results[0]
	var is_enemy_left = nearness_results[1]

	$Player.near_enemy(is_near_enemy, is_enemy_left)
