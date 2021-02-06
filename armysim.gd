extends Node

const Soldier = preload("Soldier.tscn")

func _ready():
	var soldierA = Soldier.instance()
	soldierA.hp = 3
	
	var soldierB = Soldier.instance()
	soldierB.hp = 6

	while (true): 
		print("Solider A attacks soldier B")
		soldierB.hp -= 1
		print("Soldier B HP is now: " + str(soldierB.hp))
		if soldierB.hp <= 0: 
			print("SOLDIER B IS DEAD")
			break
		print("Solider B attacks soldier A")
		soldierA.hp -= 1
		print("Soldier A HP is now: " + str(soldierA.hp))
		if soldierA.hp <= 0: 
			print("SOLDIER A IS DEAD")
			break
	
	print("")
	print("Attack done")
	if soldierA.hp <= 0:
		print("SOLDIER B WINS!")
	elif soldierB.hp <= 0:
		 print("SOLDIER A WINS!")
	else: 
		print("No-one wins")

func _process(delta):
	pass
