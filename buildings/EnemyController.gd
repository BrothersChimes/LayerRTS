extends Node2D

const MAX_INT = 9223372036854775807
const ENEMY_START_POS = 500
const ground_level = 162
const distance_between_gremlins = 256

var all_enemies = []
var Gremlin = preload("../enemies/Gremlin.tscn")

func _ready(): 
	create_gremlins()

func create_gremlins(): 
	var gremlin 
	for x in range(1,5):
		var gremlin_pos = Vector2(ENEMY_START_POS + x*distance_between_gremlins, ground_level)
		create_gremlin("Gremlin " + str(x), gremlin_pos)

func create_gremlin(display_name, gremlin_pos): 
	var gremlin = Gremlin.instance()
	gremlin.position = gremlin_pos
	all_enemies.append(gremlin)
	gremlin.display_name  = display_name
	add_child(gremlin)

func signal_player_pos_to_enemies(player_pos_x): 
	for enemy in all_enemies: 
		enemy.signal_player_pos(player_pos_x)
		
#
#signal deal_damage(amount)
#signal enemy_near_player(enemy)
#signal enemy_enters_battle(enemy)
#signal enemy_exits_battle(enemy)
#signal enemy_died(enemy) 
#
#var GremlinWalk = preload("../enemies/GremlinWalk.tscn")
#var GremlinBattle = preload("../enemies/GremlinBattle.tscn")
#var GremlinDie = preload("../enemies/GremlinDie.tscn")
#var walking_enemies = []
#var battle_instances = []
#
#const MAX_INT = 9223372036854775807
#const ENEMY_START_POS = 500
#const ground_level = 162
#
## const nearness_epsilon = 20
#const distance_between_gremlins = 256
#func _ready():
#	create_gremlins()
#
#func create_gremlins(): 
#	var gremlin 
#	#for x in range(1,20): 
#	for x in range(1,5):
#		gremlin = GremlinWalk.instance()
#		gremlin.position = Vector2(ENEMY_START_POS + x*distance_between_gremlins, ground_level)
#		walking_enemies.append(gremlin)
#		gremlin.connect("near_player", self, "_on_enemy_near_player")
#		gremlin.connect("enter_battle", self, "_on_enemy_enters_battle")
#		gremlin.connect("exit_battle", self, "_on_enemy_exits_battle")
#		gremlin.connect("deal_damage", self, "_on_enemy_deals_damage")
#		gremlin.connect("dies", self, "_on_enemy_dies")
#		gremlin.set_display_name("Gremlin " + str(x))
#		add_child(gremlin)
#
#func _on_enemy_near_player(enemy): 
#	walking_enemies.remove(walking_enemies.find(enemy))
#	var battle_instance = GremlinBattle.instance()
#	battle_instance.display_name = enemy.display_name
#	battle_instance.position = enemy.position
#	battle_instance.health = enemy.health
#	battle_instances.append(battle_instance)
#	battle_instance.connect("near_player", self, "_on_enemy_near_player")
#	battle_instance.connect("enter_battle", self, "_on_enemy_enters_battle")
#	battle_instance.connect("exit_battle", self, "_on_enemy_exits_battle")
#	battle_instance.connect("deal_damage", self, "_on_enemy_deals_damage")
#
#
#	add_child(battle_instance)
#	# print("Enemy " + str(enemy) + " has entered battle.")
#	emit_signal("enemy_near_player", battle_instance)
#
#func _on_enemy_enters_battle(enemy): 
#	# print("Enemy " + str(enemy) + " has entered battle.")
#	emit_signal("enemy_enters_battle", enemy)
#
#func _on_enemy_exits_battle(enemy): 
#	emit_signal("enemy_exits_battle", enemy)
#	var walk_instance = GremlinWalk.instance()
#	walk_instance.display_name = enemy.display_name
#	walk_instance.health = enemy.health
#	walking_enemies.append(walk_instance)
#	walk_instance.position = enemy.position
#	battle_instances.remove(battle_instances.find(enemy))
#
#	# TODO
#	print("Enemy " + str(enemy) + " LEAVES battle.")
#
#func _on_enemy_deals_damage(amount): 
#	emit_signal("deal_damage", amount)
#
#func nearest_enemy_to(player_pos_x, is_left): 
#	var nearest_enemy
#	var closest_distance = MAX_INT
#
#	for enemy in walking_enemies: 
#		var enemy_pos_x = enemy.position.x
#		if is_left and enemy_pos_x < player_pos_x: 
#			if player_pos_x - enemy_pos_x < closest_distance:
#				closest_distance = player_pos_x - enemy_pos_x
#				nearest_enemy = enemy 
#		if not is_left and enemy_pos_x > player_pos_x: 
#			if enemy_pos_x - player_pos_x < closest_distance:
#				closest_distance = player_pos_x - enemy_pos_x
#				nearest_enemy = enemy 
#
#	for enemy in battle_instances: 
#		var enemy_pos_x = enemy.position.x
#		if is_left and enemy_pos_x < player_pos_x: 
#			if player_pos_x - enemy_pos_x < closest_distance:
#				closest_distance = player_pos_x - enemy_pos_x
#				nearest_enemy = enemy 
#		if not is_left and enemy_pos_x > player_pos_x: 
#			if enemy_pos_x - player_pos_x < closest_distance:
#				closest_distance = player_pos_x - enemy_pos_x
#				nearest_enemy = enemy 
#	return nearest_enemy
#
#func all_enemies_within(player_pos_x, distance, is_left): 
#	var close_enemies = []
#	for enemy in walking_enemies: 
#		var enemy_pos_x = enemy.position.x
#		if is_left and enemy_pos_x < player_pos_x: 
#			if player_pos_x - enemy_pos_x < distance:
#				close_enemies.append(enemy) 
#		if not is_left and enemy_pos_x > player_pos_x: 
#			if enemy_pos_x - player_pos_x < distance:
#				close_enemies.append(enemy) 
#	for enemy in battle_instances: 
#		var enemy_pos_x = enemy.position.x
#		if is_left and enemy_pos_x < player_pos_x: 
#			if player_pos_x - enemy_pos_x < distance:
#				close_enemies.append(enemy) 
#		if not is_left and enemy_pos_x > player_pos_x: 
#			if enemy_pos_x - player_pos_x < distance:
#				close_enemies.append(enemy) 
#	return close_enemies
#
## Returns a pair of values
#func check_and_project_for_enemies_near_player(player_pos_x):
#	var return_values = []
#
#	for enemy in walking_enemies: 
#		var enemy_pos_x = enemy.position.x
#		var nearness_epsilon = enemy.get_attack_range()
#		if abs(player_pos_x - enemy_pos_x) < nearness_epsilon: 
#			return_values = []
#			return_values.append(true)
#			var is_enemy_left = enemy_pos_x < player_pos_x
#			return_values.append(is_enemy_left)
#			enemy.is_near_player(not is_enemy_left)
#		else:
#			enemy.is_not_near_player()
#
#
#	for enemy in battle_instances: 
#		var enemy_pos_x = enemy.position.x
#		var nearness_epsilon = enemy.get_attack_range()
#		if abs(player_pos_x - enemy_pos_x) < nearness_epsilon: 
#			return_values = []
#			return_values.append(true)
#			var is_enemy_left = enemy_pos_x < player_pos_x
#			return_values.append(is_enemy_left)
#		else:
#			enemy.is_not_near_player()
#
#
#	if return_values.empty():
#		return_values.append(false)
#		return_values.append(false)
#	return return_values
#
#func check_and_project_for_enemies_near_battle(battle_pos_x):
#	pass
##	var is_an_enemy_near = false
##	for enemy in enemies: 
##		var enemy_pos_x = enemy.position.x
##		var battle_nearness_epsilon = 64
##		if abs(battle_pos_x - enemy_pos_x) < battle_nearness_epsilon: 
##
##			var is_enemy_left = enemy_pos_x < battle_pos_x
##			enemy.is_near_battle()
##			is_an_enemy_near = true
##		else:
##			enemy.is_not_near_battle()
##	return is_an_enemy_near
#
#func deal_damage_to(enemy, damage): 
#	enemy.take_damage(damage)
#
#func _on_walking_enemy_dies(enemy): 
#	var death_instance = GremlinDie.instance()
#	death_instance.position = enemy.position
#	add_child(death_instance)
#	walking_enemies.remove(walking_enemies.find(enemy))
#	emit_signal("enemy_died", enemy)	
#
#func _on_battle_enemy_dies(enemy): 
#	var death_instance = GremlinDie.instance()
#	death_instance.position = enemy.position
#	add_child(death_instance)
#	battle_instances.remove(battle_instances.find(enemy))
#	emit_signal("enemy_died", enemy)

