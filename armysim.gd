extends Node

const Soldier = preload("Soldier.tscn")

func _ready():
	var soldierA = Soldier.instance()
	soldierA.hp = 5
	soldierA.display_name = "Soldier A"
	
	var soldierB = Soldier.instance()
	soldierB.hp = 3
	soldierB.display_name = "Soldier B"

	while (true): 
		print(soldierA.display_name + " attacks " + soldierB.display_name)
		soldierB.hp -= 1
		print(soldierB.display_name + " HP is now: " + str(soldierB.hp))
		if soldierB.hp <= 0: 
			print(soldierB.display_name + " IS DEAD")
			break
		print(soldierB.display_name + " attacks " + soldierA.display_name)
		soldierA.hp -= 1
		print(soldierA.display_name + " HP is now: " + str(soldierA.hp))
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
