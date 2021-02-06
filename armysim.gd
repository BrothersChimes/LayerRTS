extends Node

const Soldier = preload("Soldier.tscn")

var soldierA
var soldierB

func create_soldiers_for_test(): 
	soldierA = Soldier.instance()
	soldierA.hp = 5
	soldierA.display_name = "Soldier A"
	
	soldierB = Soldier.instance()
	soldierB.hp = 3
	soldierB.display_name = "Soldier B"

func _ready():
	create_soldiers_for_test()

	while (true): 
		attacker_attacks_defender(soldierA, soldierB)
		if soldierB.hp <= 0: 
			print(soldierB.display_name + " IS DEAD")
			break
		attacker_attacks_defender(soldierB, soldierA)
		if soldierA.hp <= 0: 
			print(soldierA.display_name + " IS DEAD")
			break
	
	print("")
	print("Attack done")
	if soldierA.hp <= 0:
		print(soldierB.display_name + " WINS")
	elif soldierB.hp <= 0:
		print(soldierA.display_name + " IS DEAD")
	else: 
		print("No-one wins")



func _process(delta):
	pass

func attacker_attacks_defender(attacker, defender): 
	print(attacker.display_name + " attacks " + defender.display_name)
	defender.hp -= 1
	print(defender.display_name + " HP is now: " + str(defender.hp))
	
