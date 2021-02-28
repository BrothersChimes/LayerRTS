extends Node

const Soldier = preload("Soldier.tscn")
const Army = preload("Army.tscn")

const army_height = 128
const distance_between_soldiers = 32

const armyAxPos = 384
const armyBxPos = armyAxPos + distance_between_soldiers

var armyA
var armyB

func create_soldiers_for_test(): 
	armyA = Army.instance()
	armyB = Army.instance()
	var soldier
	
	armyA.display_name = "Army A"
	armyA.distance_between_soldiers = distance_between_soldiers
	armyA.set_location(Vector2(armyAxPos, army_height))
	armyA.is_facing_right = true
		
	create_soldier_A(1,60)
	create_soldier_A(2,60)
	create_soldier_A(3,60) 
	create_soldier_A(4,60) 
	create_soldier_A(5,60)
	create_soldier_A(6,60)
	create_soldier_A(7,60) 
	create_soldier_A(8,60) 
		
	armyB.display_name = "Army B"
	armyB.distance_between_soldiers = distance_between_soldiers
	armyB.set_location(Vector2(armyBxPos, army_height))
	armyB.is_facing_right = false
	
	create_soldier_B(1,60)
	create_soldier_B(2,60)
	create_soldier_B(3,60)
	create_soldier_B(4,60)
	create_soldier_B(5,60)
	create_soldier_B(6,60)
	create_soldier_B(7,60)
	create_soldier_B(8,60)
		
	return [armyA, armyB]

func create_soldier_A(number, stamina): 
	var soldier = Soldier.instance()
	soldier.hp = 2
	soldier.stamina = stamina
	soldier.display_name = "A" + str(number)
	soldier.position = Vector2(armyAxPos-distance_between_soldiers*(number-1)*5-128,army_height)
	soldier.expected_x_position = armyAxPos-distance_between_soldiers*(number-1)
	soldier.set_sprite_idle()
	armyA.add_soldier(soldier)
	
func create_soldier_B(number, stamina): 
	var soldier = Soldier.instance()
	soldier.hp = 2
	soldier.stamina = stamina
	soldier.display_name = "B" + str(number)
	soldier.position = Vector2(armyBxPos+distance_between_soldiers*(number-1)*5+128,army_height)
	soldier.expected_x_position = armyBxPos+distance_between_soldiers*(number-1)
	soldier.set_sprite_idle()
	soldier.face_left()
	armyB.add_soldier(soldier)
