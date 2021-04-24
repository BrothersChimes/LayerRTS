extends Node

var armyA
var armyB

var attack_army
var defend_army
var attack_archers
var defend_archers

const base_time = 0.2

const phase_clash_allowed_time = base_time*2
const phase_defend_allowed_time = base_time*2
const phase_stunned_allowed_time = base_time*1
const phase_cycle_allowed_time_if_alive = base_time*1
const phase_cycle_allowed_time_if_dead = base_time*1

const phase_loose_allowed_time = base_time*2

var time_to_next_melee_phase = 0
var time_to_next_ranged_phase = 0
var is_attacker_ready = false
var is_defender_ready = false
var archers_waiting = 0

enum BigPhase {CYCLE_LIVE, ATTACKS, CYCLE_DEAD}
var big_phase = BigPhase.CYCLE_LIVE

enum MeleePhase {READY_ATTACK, WAIT_FOR_CLASH, CLASH, DAMAGE_CHECK, DEFEND, DEATH, STUNNED, DAMAGE,
	CYCLE_LIVE, CYCLE_DEAD}
var melee_phase = MeleePhase.READY_ATTACK

enum RangedPhase {READY_ARCHERY, AWAIT_LOOSE, LOOSE, CYCLE_DEAD, CYCLE_LIVE} 
var ranged_phase  = RangedPhase.READY_ARCHERY


enum State {OUT_OF_COMBAT, COMBAT, END_COMBAT}
var state = State.OUT_OF_COMBAT
const SoldierType = preload("SoldierType.gd").SoldierType

func start_combat_with_armies(armyA_, armyB_):
	randomize()
	armyA = armyA_
	armyB = armyB_
	attack_army = armyA
	defend_army = armyB
	attack_archers = armyA
	defend_archers = armyB
	armyA.start_combat()
	armyB.start_combat()
	state = State.COMBAT
	register_all_soldiers()
	
func register_all_soldiers(): 
	for soldier in armyA.soldiers: 
		soldier.connect("attack_ready", self, "_on_soldier_attack_ready")
		if soldier.soldier_type == SoldierType.RANGED: 
			soldier.connect("archery_ready", self, "_on_soldier_archery_ready")
	for soldier in armyB.soldiers: 
		soldier.connect("attack_ready", self, "_on_soldier_attack_ready")
		if soldier.soldier_type == SoldierType.RANGED: 
			soldier.connect("archery_ready", self, "_on_soldier_archery_ready")
			
func _process(delta):
	if state == State.COMBAT:
		perform_combat_state_action(delta)
	elif state == State.END_COMBAT:
		perform_end_combat_state_action()

func switch_attacker(): 	
	var temp = defend_army
	defend_army = attack_army
	attack_army = temp

func perform_end_combat_state_action(): 
	state = State.OUT_OF_COMBAT
	# TODO You need to figure out which army died and get rid of them? 
	armyA.end_combat()
	armyB.end_combat()
	
func calculate_whether_damaged(): 
	var defender = defend_army.front()
	var defended_roll = randi()%100
	if defended_roll < defender.stamina: 
		return false
	return true
		
func perform_combat_state_action(delta): 
	match(big_phase): 
		BigPhase.CYCLE_LIVE: 
			cycle_live_phase()
			time_to_next_melee_phase = phase_cycle_allowed_time_if_alive
			time_to_next_ranged_phase = phase_cycle_allowed_time_if_alive
			switch_attacker()
			switch_archers()
			big_phase = BigPhase.ATTACKS
			melee_phase = MeleePhase.READY_ATTACK
			ranged_phase = RangedPhase.READY_ARCHERY
		BigPhase.CYCLE_DEAD: 
			cycle_dead_phase()
			time_to_next_melee_phase = phase_cycle_allowed_time_if_dead
			time_to_next_ranged_phase = phase_cycle_allowed_time_if_alive
			switch_attacker()
			switch_archers()
			big_phase = BigPhase.ATTACKS
			melee_phase = MeleePhase.READY_ATTACK
			ranged_phase = RangedPhase.READY_ARCHERY
		BigPhase.ATTACKS:
			perform_melee_combat_state_action(delta)
			perform_ranged_combat_state_action(delta)
			if melee_phase == MeleePhase.CYCLE_DEAD: 
				if ranged_phase == RangedPhase.CYCLE_LIVE or ranged_phase == RangedPhase.CYCLE_DEAD:
					big_phase = BigPhase.CYCLE_DEAD
			if ranged_phase == RangedPhase.CYCLE_DEAD: 
				if melee_phase == MeleePhase.CYCLE_LIVE or melee_phase == MeleePhase.CYCLE_DEAD:
					big_phase = BigPhase.CYCLE_DEAD
			if melee_phase == MeleePhase.CYCLE_LIVE and ranged_phase == RangedPhase.CYCLE_LIVE:
				big_phase = BigPhase.CYCLE_LIVE
				
func perform_melee_combat_state_action(delta): 
	if time_to_next_melee_phase <= 0:
		match(melee_phase): 
			MeleePhase.READY_ATTACK: 
				ready_attack_phase()
			MeleePhase.WAIT_FOR_CLASH: 
				wait_for_clash_phase()
			MeleePhase.CLASH:
				clash_phase()
				time_to_next_melee_phase = phase_clash_allowed_time
				melee_phase = MeleePhase.DAMAGE_CHECK
			MeleePhase.DAMAGE_CHECK: 
				var defender = defend_army.front()
				if calculate_whether_damaged(): 
					defender.take_hp_damage(1)
					melee_phase = MeleePhase.DAMAGE
				else: 
					melee_phase = MeleePhase.DEFEND
				defender.take_stamina_damage(20)
				time_to_next_melee_phase = 0
			MeleePhase.DEFEND: 
				defend_phase()
				time_to_next_melee_phase = phase_defend_allowed_time
				switch_attacker()
				melee_phase = MeleePhase.READY_ATTACK
			MeleePhase.DAMAGE: 
				var defender = defend_army.front()
				var attacker = attack_army.front()
				attacker.set_sprite_attack_move_in()
				defender.set_sprite_damaged()
				if defender.hp <= 0:
					melee_phase = MeleePhase.DEATH
				else: 
					melee_phase = MeleePhase.STUNNED
				time_to_next_melee_phase = phase_defend_allowed_time
			MeleePhase.DEATH: 
				death_phase()
				time_to_next_melee_phase = 0
				melee_phase = MeleePhase.CYCLE_DEAD
			MeleePhase.STUNNED: 
				var defender = defend_army.front()
				defender.set_sprite_idle()
				time_to_next_melee_phase = phase_stunned_allowed_time
				melee_phase = MeleePhase.CYCLE_LIVE
	else: 
		time_to_next_melee_phase -= delta
		
func wait_for_clash_phase(): 
	pass
	
func ready_attack_phase(): 
	var attacker = attack_army.front()
	var defender = defend_army.front()
	is_attacker_ready = false
	is_defender_ready = false
	attacker.ready_for_attack()
	defender.ready_for_attack()
	melee_phase = MeleePhase.WAIT_FOR_CLASH
	
func _on_soldier_attack_ready(soldier):
	if soldier == attack_army.front(): 
		is_attacker_ready = true
	if soldier == defend_army.front(): 
		is_defender_ready = true
	if is_attacker_ready and is_defender_ready: 
		melee_phase = MeleePhase.CLASH
	
func clash_phase(): 
	var attacker = attack_army.front()
	var defender = defend_army.front()
	attacker.set_sprite_attack()
	defender.set_sprite_attack_defend()

func defend_phase(): 
	var attacker = attack_army.front()
	attacker.set_sprite_attack_move_in()
	var defender = defend_army.front()
	defender.set_sprite_defend()

func death_phase(): 
	var defender = defend_army.front()
	var attacker = attack_army.front()
	attacker.set_sprite_attack_move_in()
	defend_army.kill_front_soldier()
	attack_army.advance(1)
	defend_army.retreat(1)
	if defend_army.size() == 0: 
		attack_army.set_all_melee_soldiers_idle()
		melee_phase = MeleePhase.READY_ATTACK
		state = State.END_COMBAT
		return

func cycle_live_phase(): 
	defend_army.set_all_soldiers_idle()
	attack_army.set_all_soldiers_idle()
	attack_army.sort_soldiers()
	defend_army.sort_soldiers()
	attack_army.cycle_soldiers()
	defend_army.cycle_soldiers()

func cycle_dead_phase(): 
	defend_army.set_all_soldiers_idle()
	attack_army.set_all_soldiers_idle()
	attack_army.sort_soldiers()
	defend_army.sort_soldiers()
	defend_army.cycle_soldiers()
	attack_army.cycle_soldiers()

func perform_ranged_combat_state_action(delta): 
	if time_to_next_ranged_phase <= 0:
		match(ranged_phase): 
			RangedPhase.READY_ARCHERY: 
				ready_archery_phase()
			RangedPhase.AWAIT_LOOSE: 
				pass
			RangedPhase.LOOSE:
				loose_phase()
				time_to_next_ranged_phase = phase_loose_allowed_time
				ranged_phase = RangedPhase.CYCLE_LIVE
	else: 
		time_to_next_ranged_phase -= delta
	

func _on_soldier_archery_ready(soldier):
	archers_waiting = archers_waiting - 1
	print("archers waiting: " + str(archers_waiting))
	if archers_waiting == 0: 
		ranged_phase = RangedPhase.LOOSE
	
func ready_archery_phase(): 
	var i = 0
	for soldier in attack_army.soldiers:
		if i == 0:
			i = i + 1
			continue
		if soldier.soldier_type == SoldierType.RANGED: 
			archers_waiting = archers_waiting+1
			print("ready_archery_phase archers_waiting " + str(archers_waiting))
			soldier.ready_for_archery()
	ranged_phase = RangedPhase.AWAIT_LOOSE
			
func loose_phase(): 
	print("LOOSE")
	var i = 0
	for soldier in attack_army.soldiers:
		if i == 0:
			i = i+1
			continue
		if soldier.soldier_type == SoldierType.RANGED: 
			print("setting soldier: " + str(soldier.display_name) + " to attack")
			soldier.set_sprite_attack() 

func switch_archers(): 	
	var temp = defend_archers
	defend_archers = attack_archers
	attack_archers = temp
