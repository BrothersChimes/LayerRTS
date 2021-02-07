extends Node

const Soldier = preload("Soldier.tscn")

func create_soldiers_for_test(): 
	var armies = [[],[]]
	var soldier
	 
	soldier = Soldier.instance()
	soldier.hp = 1
	soldier.display_name = "A1"
	armies[0].append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 2
	soldier.display_name = "A2"
	armies[0].append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "A3"
	armies[0].append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "B1"
	armies[1].append(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 5
	soldier.display_name = "B2"
	armies[1].append(soldier)

	return armies
