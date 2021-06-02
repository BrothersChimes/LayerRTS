extends Node2D

var Gremlin = preload("../enemies/Gremlin.tscn")
var enemies = []

const ENEMY_START_POS = 400
const ground_level = 162

const nearness_epsilon = 20

func _ready():
	var gremlin 
	gremlin = Gremlin.instance()
	gremlin.position = Vector2(ENEMY_START_POS, ground_level)
	enemies.append(gremlin)
	add_child(gremlin)

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

