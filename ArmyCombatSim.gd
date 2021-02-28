extends Node

var armyA
var armyB

var attack_army
var defend_army

const base_speed = 0.2

const phase_clash_allowed_time = base_speed*2
const phase_defend_allowed_time = base_speed*2
const phase_cycle_allowed_time_if_alive = base_speed*1
const phase_cycle_allowed_time_if_dead = base_speed*1

var time_to_next_phase = 0
var is_attacker_ready = false
var is_defender_ready = false

enum Phase {READY_ATTACK, CLASH, DAMAGE_CHECK, DEFEND, DEATH, 
	DAMAGE, CYCLE_LIVE, CYCLE_DEAD}
var phase = Phase.READY_ATTACK

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

func switch_attacker(): 	
	var temp = defend_army
	defend_army = attack_army
	attack_army = temp

func perform_end_combat_state_action(): 
	state = State.OUT_OF_COMBAT

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
				print("Damaged roll: " + str(damaged_roll))
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
				phase = Phase.CYCLE_LIVE
			Phase.DAMAGE: 
				var defender = defend_army.front()
				var attacker = attack_army.front()
				attacker.set_sprite_attack_move_in()
				defender.set_sprite_damaged()
				if defender.hp <= 0:
					phase = Phase.DEATH
				else: 
					phase = Phase.CYCLE_LIVE
				time_to_next_phase = phase_defend_allowed_time
			Phase.DEATH: 
				death_phase()
				time_to_next_phase = 0
				phase = Phase.CYCLE_DEAD
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
	var attacker = attack_army.front()
	attacker.connect("attack_ready", self, "_on_attacker_attack_ready")
	var defender = defend_army.front()
	defender.connect("attack_ready", self, "_on_defender_attack_ready")
	is_attacker_ready = false
	is_defender_ready = false
	attacker.ready_for_attack()
	defender.ready_for_attack()
	
func _on_attacker_attack_ready(): 
	is_attacker_ready = true
	if is_defender_ready: 
		phase = Phase.CLASH

func _on_defender_attack_ready(): 
	is_defender_ready = true
	if is_attacker_ready: 
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
		phase = Phase.ATTACK
		state = State.END_COMBAT
		return
	
	defender = defend_army.front()	

func cycle_live_phase(): 
	defend_army.set_all_soldiers_idle()
	attack_army.set_all_soldiers_idle()
	defend_army.move_soldier_to_back()
	defend_army.cycle_soldiers()
	attack_army.cycle_soldiers()

func cycle_dead_phase(): 
	defend_army.set_all_soldiers_idle()
	attack_army.set_all_soldiers_idle()
	defend_army.cycle_soldiers()
	attack_army.cycle_soldiers()

