extends Node

var armyA
var armyB

var attack_army
var defend_army

const phase_attack_allowed_time = 1
const phase_defend_allowed_time = 1
const phase_death_allowed_time = 1
const phase_cycle_allowed_time = 1

var time_to_next_phase = 0

enum Phase {ATTACK, DEATH_CHECK, DEFEND, DEATH, CYCLE}
var phase = Phase.ATTACK

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
	# attack_army.set_all_soldiers_idle()
	# defend_army.set_all_soldiers_idle()
	
	attacking_army_attacks_defending_army(delta)

func switch_attacker(): 	
	var temp = defend_army
	defend_army = attack_army
	attack_army = temp

func perform_end_combat_state_action(): 
	print("Attack done")
	if armyA.size() == 0 :
		print(armyB.display_name + " won")
	elif armyB.size() == 0: 
		print(armyA.display_name + " won")
	else: 
		print("No-one won") # Shouldn't happen
	state = State.OUT_OF_COMBAT

func attacking_army_attacks_defending_army(delta): 
	if time_to_next_phase <= 0:
		if phase == Phase.ATTACK:
			print("ATTACK PHASE")
			attack_phase()
			time_to_next_phase = phase_attack_allowed_time
			phase = Phase.DEATH_CHECK
		elif phase == Phase.DEATH_CHECK: 
			var defender = defend_army.front()
			print("DEFENDER " + defender.display_name 
				+ " HP AT: " + str(defender.hp))
			if defender.hp <= 0:
				phase = Phase.DEATH
			else: 
				phase = Phase.DEFEND
			time_to_next_phase = 0
		elif phase == Phase.DEFEND: 
			print("DEFEND PHASE")
			defend_phase()
			time_to_next_phase = phase_defend_allowed_time
			phase = Phase.CYCLE
		elif phase == Phase.DEATH: 
			print("DEATH PHASE")
			death_phase()
			time_to_next_phase = phase_death_allowed_time
			phase = Phase.CYCLE
		elif phase == Phase.CYCLE: 
			print("CYCLE PHASE")
			cycle_phase()
			time_to_next_phase = phase_cycle_allowed_time
			switch_attacker()
			phase = Phase.ATTACK
	else: 
		time_to_next_phase -= delta
		
func attack_phase(): 
	var attacker = attack_army.front()
	var defender = defend_army.front()
	attacker_attacks_defender(attacker, defender)

func defend_phase(): 
	var defender = defend_army.front()
	defender.set_sprite_defend()

func death_phase(): 
	var defender = defend_army.front()
	defend_army.kill_front_soldier()
	
	if defend_army.size() == 0: 
		print("The defending army has no soldiers left.")
		attack_army.set_all_soldiers_idle()
		phase = Phase.ATTACK
		state = State.END_COMBAT
		return
		
	defender = defend_army.front()	
	
	if defend_army.size() == 1: 
		print(defender.display_name + " is the only one left.")
		
	print(defender.display_name + " is now in front.")
	
func cycle_phase(): 
	defend_army.set_all_soldiers_idle()
	attack_army.set_all_soldiers_idle()
	# TODO replace with proper animation
	
	var defender = defend_army.front()
	if defend_army.size() == 1: 
		print(defender.display_name + " is the only one left and so does not cycle.")
		return
	
	print(defender.display_name + " CYCLES TO BACK")
	defend_army.move_soldier_to_back()
	defender = defend_army.front()
	print(defender.display_name + " is now at the front.")
	print("")
		
func attacker_attacks_defender(attacker, defender): 
	print(attacker.display_name + " attacks " + defender.display_name)
	attacker.set_sprite_attack()
	defender.hp -= 1
	print(defender.display_name + " HP is now: " + str(defender.hp))
