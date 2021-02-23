extends Node

var armyA
var armyB

var attack_army
var defend_army

const time_between_rounds = 1
var time_since_last_round = time_between_rounds

enum State {OUT_OF_COMBAT, COMBAT, END_COMBAT}
var state = State.OUT_OF_COMBAT

func start_combat_with_armies(armyA_, armyB_):
	armyA = armyA_
	armyB = armyB_
	attack_army = armyA
	defend_army = armyB
	state = State.COMBAT

func _process(delta):
	if state == State.COMBAT:
		perform_combat_state_action(delta)
	elif state == State.END_COMBAT:
		perform_end_combat_state_action()
	
func perform_combat_state_action(delta): 
	time_since_last_round -= delta
	if time_since_last_round > 0: 
		return
	time_since_last_round = time_between_rounds
	
	attack_army.set_all_soldiers_idle()
	defend_army.set_all_soldiers_idle()
	
	attacking_army_attacks_defending_army(attack_army, defend_army)
	print("")
	if defend_army.size() == 0: 
		state = State.END_COMBAT
		return
		
	print("Attack army before: " + attack_army.display_name)	
	var temp = defend_army
	defend_army = attack_army
	attack_army = temp
	print("Attack army after: " + attack_army.display_name)	

func perform_end_combat_state_action(): 
	print("Attack done")
	if armyA.size() == 0 :
		print(armyB.display_name + " won")
	elif armyB.size() == 0: 
		print(armyA.display_name + " won")
	else: 
		print("No-one won") # Shouldn't happen
	state = State.OUT_OF_COMBAT

func attacking_army_attacks_defending_army(attack_army_, defend_army_): 
	# Get damage from attack army
	# Deal damage to defend army - defend army does its deaths here 
	# Give defend army a chance to retreat
	# Give defend army a chance to cycle
	# Does attack army cycle? 

	# Comment: may need to think of this in terms of states to give armies time 
	# to animate etc. 
	
	var attacker = attack_army_.front()
	var defender = defend_army_.front()
	attacker_attacks_defender(attacker, defender)
	
	if defender.hp <= 0:
		defend_army_.kill_front_soldier()
		
		if defend_army_.size() == 0: 
			print("The defending army has no soldiers left.")
			return

		defender = defend_army_.front()	
		
		if defend_army_.size() == 1: 
			print(defender.display_name + " is the only one left.")
			return
			
		print(defender.display_name + " is now in front.")
		return

	if defend_army_.size() == 1: 
		print(defender.display_name + " is the only one left and so does not cycle.")
		return
				
	print(defender.display_name + " CYCLES TO BACK")
	defend_army_.move_soldier_to_back()
	defender = defend_army_.front()
	print(defender.display_name + " is now at the front.")
		
func attacker_attacks_defender(attacker, defender): 
	print(attacker.display_name + " attacks " + defender.display_name)
	attacker.set_sprite_attack()
	defender.set_sprite_defend()
	defender.hp -= 1
	print(defender.display_name + " HP is now: " + str(defender.hp))
