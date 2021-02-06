extends Node

const Soldier = preload("Soldier.tscn")

var armyA
var armyB 

func create_soldiers_for_test(): 
	armyA = []
	armyB = []
	
	var soldier
	 
	soldier = Soldier.instance()
	soldier.hp = 1
	soldier.display_name = "A1"
	armyA.append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 2
	soldier.display_name = "A2"
	armyA.append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "A3"
	armyA.append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "B1"
	armyB.append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 5
	soldier.display_name = "B2"
	armyB.append(soldier)

func _ready():
	create_soldiers_for_test()
	var attack_army = armyA
	var defend_army = armyB
	
	while (true): 
		attacking_army_attacks_defending_army(attack_army, defend_army)
		print("")
		if defend_army.size() == 0: 
			break
		
		var temp = defend_army
		defend_army = attack_army
		attack_army = temp

	print("Attack done")
	
	if armyA.size() == 0 :
		print("Army B won")
	elif armyB.size() == 0: 
		print("Army A won")
	else: 
		print("No-one won") # Shouldn't happen

func _process(delta):
	pass

func attacking_army_attacks_defending_army(attack_army, defend_army): 
	var attacker = attack_army[0]
	var defender = defend_army[0]
	attacker_attacks_defender(attacker, defender)
	
	if defender.hp <= 0:
		print(defender.display_name + " IS DEAD")
		defend_army.pop_front()
		
		if defend_army.size() == 0: 
			print("The defending army has no soldiers left.")
			return

		defender = defend_army.front()	
		
		if defend_army.size() == 1: 
			print(defender.display_name + " is the only one left.")
			return
			
		print(defender.display_name + " is now in front.")
		return

	if defend_army.size() == 1: 
		print(defender.display_name + " is the only one left and so does not cycle.")
		return
				
	print(defender.display_name + " CYCLES TO BACK")
	defend_army.push_back(defend_army.pop_front())
	defender = defend_army.front()
	print(defender.display_name + " is now at the front.")
		
func attacker_attacks_defender(attacker, defender): 
	print(attacker.display_name + " attacks " + defender.display_name)
	defender.hp -= 1
	print(defender.display_name + " HP is now: " + str(defender.hp))
		
	
