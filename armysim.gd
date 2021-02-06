extends Node

const Soldier = preload("Soldier.tscn")

var armyA
var armyB 

func create_soldiers_for_test(): 
	armyA = []
	armyB = []
	
	var soldierA = Soldier.instance()
	soldierA.hp = 5
	soldierA.display_name = "Soldier A"
	armyA.append(soldierA)
	
	var soldierB = Soldier.instance()
	soldierB.hp = 3
	soldierB.display_name = "Soldier B"
	armyB.append(soldierB)

func _ready():
	create_soldiers_for_test()
	var attack_army = armyA
	var defend_army = armyB
	
	while (true): 
		attacking_army_attacks_defending_army(attack_army, defend_army)
		if defend_army.size() == 0: 
			break
		
		var temp = defend_army
		defend_army = attack_army
		attack_army = temp
	
	print("")
	print("Attack done")

func _process(delta):
	pass

func attacking_army_attacks_defending_army(attack_army, defend_army): 
	var attacker = attack_army[0]
	var defender = defend_army[0]
	attacker_attacks_defender(attacker, defender)
	if defender.hp <= 0:
		print(defender.display_name + " IS DEAD")
		defend_army.pop_front()

func attacker_attacks_defender(attacker, defender): 
	print(attacker.display_name + " attacks " + defender.display_name)
	defender.hp -= 1
	print(defender.display_name + " HP is now: " + str(defender.hp))
		
	
