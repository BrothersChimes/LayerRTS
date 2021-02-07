extends Node

const Soldier = preload("Soldier.tscn")
const Army = preload("Army.tscn")

func create_soldiers_for_test(): 
	var armyA = Army.instance()
	var armyB = Army.instance()
	var soldier
	 
	soldier = Soldier.instance()
	soldier.hp = 1
	soldier.display_name = "A1"
	armyA.add_soldier_to_back(soldier)
		
	soldier = Soldier.instance()
	soldier.hp = 2
	soldier.display_name = "A2"
	armyA.add_soldier_to_back(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "A3"
	armyA.add_soldier_to_back(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "B1"
	armyB.add_soldier_to_back(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 5
	soldier.display_name = "B2"
	armyB.add_soldier_to_back(soldier)
	
	return [armyA, armyB]
