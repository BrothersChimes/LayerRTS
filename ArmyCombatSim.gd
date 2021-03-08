extends Node

var armyA
var armyB

var attack_army
var defend_army

const base_time = 0.2

const phase_clash_allowed_time = base_time*2
const phase_defend_allowed_time = base_time*2
const phase_stunned_allowed_time = base_time*1
const phase_cycle_allowed_time_if_alive = base_time*1
const phase_cycle_allowed_time_if_dead = base_time*1

var time_to_next_phase = 0
var is_attacker_ready = false
var is_defender_ready = false

enum Phase {READY_ATTACK, CLASH, DAMAGE_CHECK, DEFEND, DEATH, STUNNED, 
	DAMAGE, CYCLE_LIVE, CYCLE_DEAD}
var phase = Phase.CYCLE_LIVE

enum State {OUT_OF_COMBAT, COMBAT, END_COMBAT}
var state = State.OUT_OF_COMBAT

func start_combat_with_armies(armyA_, armyB_):
	randomize()
	armyA = armyA_
	armyB = armyB_
	attack_army = armyA
	defend_army = armyB
	state = State.COMBAT
	register_all_soldiers()
	
func register_all_soldiers(): 
	for soldier in armyA.soldiers: 
		soldier.connect("attack_ready", self, "_on_soldier_attack_ready")
	for soldier in armyB.soldiers: 
		soldier.connect("attack_ready", self, "_on_soldier_attack_ready")

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
	# TODO This is a big hack
	armyA.set_x_location(1000)
	armyB.set_x_location(-1000)
	armyA.cycle_soldiers()
	armyB.cycle_soldiers()

func perform_combat_state_action(delta): 
	if time_to_next_phase <= 0:
		match(phase): 
			Phase.READY_ATTACK: 
				ready_attack_phase()
			Phase.CLASH:
				clash_phase()
				time_to_next_phase = phase_clash_allowed_time
				phase = Phase.DAMAGE_CHECK
			Phase.DAMAGE_CHECK: 
				var damaged_roll = randi()%100
				var defender = defend_army.front()
				if damaged_roll >= defender.stamina: 
					defender.take_hp_damage(1)
					phase = Phase.DAMAGE
				else: 
					phase = Phase.DEFEND
				defender.take_stamina_damage(20)
				time_to_next_phase = 0
			Phase.DEFEND: 
				defend_phase()
				time_to_next_phase = phase_defend_allowed_time
				switch_attacker()
				phase = Phase.READY_ATTACK
			Phase.DAMAGE: 
				var defender = defend_army.front()
				var attacker = attack_army.front()
				attacker.set_sprite_attack_move_in()
				defender.set_sprite_damaged()
				if defender.hp <= 0:
					phase = Phase.DEATH
				else: 
					phase = Phase.STUNNED
				time_to_next_phase = phase_defend_allowed_time
			Phase.DEATH: 
				death_phase()
				time_to_next_phase = 0
				phase = Phase.CYCLE_DEAD
			Phase.STUNNED: 
				var defender = defend_army.front()
				defender.set_sprite_idle()
				time_to_next_phase = phase_stunned_allowed_time
				phase = Phase.CYCLE_LIVE
			Phase.CYCLE_LIVE: 
				cycle_live_phase()
				time_to_next_phase = phase_cycle_allowed_time_if_alive
				switch_attacker()
				phase = Phase.READY_ATTACK
			Phase.CYCLE_DEAD: 
				cycle_dead_phase()
				time_to_next_phase = phase_cycle_allowed_time_if_dead
				switch_attacker()
				phase = Phase.READY_ATTACK
	else: 
		time_to_next_phase -= delta
		
func ready_attack_phase(): 
	# TODO I'm not sure this part is working correctly
	var attacker = attack_army.front()
	var defender = defend_army.front()
	is_attacker_ready = false
	is_defender_ready = false
	attacker.ready_for_attack()
	defender.ready_for_attack()
	
func _on_soldier_attack_ready(soldier):
	if soldier == attack_army.front(): 
		is_attacker_ready = true
	if soldier == defend_army.front(): 
		is_defender_ready = true

	if is_attacker_ready and is_defender_ready: 
		phase = Phase.CLASH
	
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
		attack_army.set_all_soldiers_idle()
		phase = Phase.READY_ATTACK
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

