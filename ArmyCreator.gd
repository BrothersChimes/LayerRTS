extends Node

const Soldier = preload("Soldier.tscn")
const Army = preload("Army.tscn")

const army_height = 92
const distance_between_soldiers = 32

const armyAxPos = 96
const armyBxPos = 160

func create_soldiers_for_test(): 
	var armyA = Army.instance()
	var armyB = Army.instance()
	var soldier
	
	armyA.display_name = "Army A"
	
	soldier = Soldier.instance()
	soldier.hp = 1
	soldier.display_name = "A1"
	soldier.position = Vector2(armyAxPos - 0,army_height)
	soldier.expected_x_position = soldier.position.x
	soldier.set_sprite_idle()
	armyA.add_soldier(soldier)
		
	soldier = Soldier.instance()
	soldier.hp = 2
	soldier.display_name = "A2"
	soldier.position = Vector2(armyAxPos - distance_between_soldiers,army_height)
	soldier.expected_x_position = soldier.position.x
	soldier.set_sprite_idle()
	armyA.add_soldier(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "A3"
	soldier.position = Vector2(armyAxPos - distance_between_soldiers*2,army_height)
	soldier.expected_x_position = soldier.position.x
	soldier.set_sprite_idle()
	armyA.add_soldier(soldier)
	
	armyB.display_name = "Army B"
	
	soldier = Soldier.instance()
	soldier.hp = 3
	soldier.display_name = "B1"
	soldier.position = Vector2(armyBxPos,army_height)
	soldier.expected_x_position = soldier.position.x
	soldier.set_sprite_idle()
	soldier.face_left()
	armyB.add_soldier(soldier)
	
	soldier = Soldier.instance()
	soldier.hp = 5
	soldier.display_name = "B2"
	soldier.position = Vector2(armyBxPos + distance_between_soldiers,army_height)
	soldier.expected_x_position = soldier.position.x
	soldier.set_sprite_idle()
	soldier.face_left()
	armyB.add_soldier(soldier)
	
	return [armyA, armyB]
