extends Node

const Soldier = preload("Soldier.tscn")
const Army = preload("Army.tscn")

func create_soldiers_for_test(): 
	var armyA = Army.instance()
	var armyB = Army.instance()
	var soldier
	
	armyA.display_name = "Army A"
	
	soldier = Soldier.instance()
	soldier.hp = 1
	soldier.display_name = "A1"
	soldier.position = Vector2(32,100)
	armyA.add_soldier(soldier)
		
	soldier = Soldier.instance()
	soldier.hp = 2
	soldier.display_name = "A2"
	soldier.position = Vector2(64,100)
	armyA.add_soldier(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "A3"
	soldier.position = Vector2(96,100)
	armyA.add_soldier(soldier)
	
	armyB.display_name = "Army B"
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "B1"
	soldier.position = Vector2(160,100)
	soldier.face_left()
	armyB.add_soldier(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 5
	soldier.display_name = "B2"
	soldier.position = Vector2(192,100)
	soldier.face_left()
	armyB.add_soldier(soldier)
	
	return [armyA, armyB]
