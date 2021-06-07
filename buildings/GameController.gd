extends Node2D

var enemies = []

const Battle = preload("res://battle/Battle.tscn")
var has_battle = false
var battle = null

func _process(delta): 
	var player_pos_x = $Player.position.x
	
	# TODO make this make more sense.
	var nearness_results = $EnemyController.check_and_project_for_enemies_near_player(player_pos_x)
	var is_near_enemy = nearness_results[0]
	var is_enemy_left = nearness_results[1]

	$Player.near_enemy(is_near_enemy, is_enemy_left)
	
	if has_battle:
		var is_near_battle = $EnemyController.check_and_project_for_enemies_near_battle(battle.battle_pos_x)

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

func _on_EnemyController_enemy_near_player(enemy):
	if not has_battle:
		battle = Battle.instance()
		battle.battle_pos_x = enemy.position.x
		has_battle = true
		battle.connect("no_enemies", self, "_on_battle_no_enemies")
		add_child(battle)
		print("Created battle: " + str(battle))
	add_enemy_to_battle(enemy, battle)

func _on_EnemyController_enemy_enters_battle(enemy):
	# print("Enemy " + str(enemy) + " has entered battle.")
	if not has_battle:
		print("NO BATTLE! THIS SHOULD NOT HAPPEN")
		return
	add_enemy_to_battle(enemy, battle)

func _on_EnemyController_enemy_exits_battle(enemy):
	remove_enemy_from_any_existing_battle(enemy)
		
func _on_EnemyController_enemy_died(enemy):
	remove_enemy_from_any_existing_battle(enemy)

func remove_enemy_from_any_existing_battle(enemy): 
	if has_battle:
		remove_enemy_from_battle(enemy, battle)

# TODO Remove enemies from battle
func remove_enemy_from_battle(enemy, battle): 
	battle.remove_enemy(enemy)
	print("Battle now has " + str(battle.enemies.size()) + " enemies.")

func add_enemy_to_battle(enemy, battle): 
	battle.add_enemy(enemy)
	print("Battle now has " + str(battle.enemies.size()) + " enemies.")

func _on_battle_no_enemies(_the_battle): 
	has_battle = false
	battle = null

