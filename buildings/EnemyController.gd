extends Node2D

var Gremlin = preload("../enemies/Gremlin.tscn")
var enemies = []

const ENEMY_START_POS = 400
const ground_level = 162

const nearness_epsilon = 20
const distance_between_gremlins = 256
func _ready():
	var gremlin 
	for x in range(1,10): 
		gremlin = Gremlin.instance()
		gremlin.position = Vector2(ENEMY_START_POS + x*distance_between_gremlins, ground_level)
		enemies.append(gremlin)
		add_child(gremlin)

func nearest_enemy_to(player_pos_x, is_left): 
	var nearest_enemy
	var closest_distance = 11000000000
	
	for enemy in enemies: 
		var enemy_pos_x = enemy.position.x
		if is_left and enemy_pos_x < player_pos_x: 
			if player_pos_x - enemy_pos_x < closest_distance:
				closest_distance = player_pos_x - enemy_pos_x
				nearest_enemy = enemy 
		if not is_left and enemy_pos_x > player_pos_x: 
			if enemy_pos_x - player_pos_x < closest_distance:
				closest_distance = player_pos_x - enemy_pos_x
				nearest_enemy = enemy 
	
	return nearest_enemy
	
# Returns a pair of values
func check_and_project_for_near_enemies(player_pos_x):
	var return_values = []
	
	for enemy in enemies: 
		var enemy_pos_x = enemy.position.x
		if abs(player_pos_x - enemy_pos_x) < nearness_epsilon: 
			return_values = []
			return_values.append(true)
			var is_enemy_left = enemy_pos_x < player_pos_x
			return_values.append(is_enemy_left)
			enemy.is_near_player(not is_enemy_left)
		else:
			enemy.is_not_near_player()
		
	if return_values.empty():
		return_values.append(false)
		return_values.append(false)
	return return_values

func kill(enemy): 
	enemies.remove(enemies.find(enemy))
	enemy.queue_free()
