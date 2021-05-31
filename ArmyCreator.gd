extends Node

const Swordsman = preload("Swordsman.tscn")
const Archer = preload("Archer.tscn")
const Army = preload("Army.tscn")

const army_height = 132

var distance_between_soldiers # = 32
var armyAxSpawnPos # = 400
var armyBxSpawnPos # = armyAxPos + distance_between_soldiers
var armyAxIntendedPos #= 400
var armyBxIntendedPos #= armyAxIntendedPos + distance_between_soldiers

var armyA
var armyB

var army_a_number = 1
var army_b_number = 1

func create_soldiers_for_march_to_combat_test(): 
	armyA = Army.instance()
	armyB = Army.instance()
	var soldier
	
	armyA.display_name = "Army A"
	armyA.distance_between_soldiers = distance_between_soldiers
	armyA.set_location(Vector2(armyAxIntendedPos, army_height))
	armyA.is_facing_right = true
	
#	create_soldier_A(30,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)
#	create_soldier_A(100,2)

	create_archer_A(80,2)
	create_archer_A(100,2)
#	create_soldier_A(40,2)
#	create_soldier_A(80,2)
	create_archer_A(80,2)
	create_archer_A(60,2)
#	create_soldier_A(100,2)
	create_archer_A(80,2)
		
	armyB.display_name = "Army B"
	armyB.distance_between_soldiers = distance_between_soldiers
	armyB.set_location(Vector2(armyBxIntendedPos, army_height))
	armyB.is_facing_right = false
	
#	create_soldier_B(30,2)
#	create_soldier_B(30,2)
#	create_archer_B(30,2)
#	create_soldier_B(30,2)
#	create_soldier_B(60,2)
#	create_archer_B(70,2) 
	create_soldier_B(100,2)
	create_soldier_B(100,2)
	create_soldier_B(100,2)
	create_soldier_B(100,2) 
	create_soldier_B(100,2)
#	create_archer_B(40, 2)
#	create_archer_B(40, 2)
#	create_archer_B(40, 2)
#	create_archer_B(40, 2)
		
	return [armyA, armyB]

	
func create_soldiers_for_march_test(): 
	armyA = Army.instance()
	
	armyA.display_name = "Army A"
	armyA.distance_between_soldiers = distance_between_soldiers
	armyA.set_location(Vector2(armyAxIntendedPos, army_height))
	armyA.is_facing_right = true
	
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	
	return [armyA]

func create_soldiers_for_combat_test(): 
	armyA = Army.instance()
	armyB = Army.instance()
	
	armyA.display_name = "Army A"
	armyA.distance_between_soldiers = distance_between_soldiers
	armyA.set_location(Vector2(armyAxIntendedPos, army_height))
	armyA.is_facing_right = true
	
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
	create_soldier_A(100,2)
		
	armyB.display_name = "Army B"
	armyB.distance_between_soldiers = distance_between_soldiers
	armyB.set_location(Vector2(armyBxIntendedPos, army_height))
	armyB.is_facing_right = false
	
	create_soldier_B(100,2)
	create_soldier_B(100,2)
	create_soldier_B(100,2) 
	create_soldier_B(100,2)
	create_soldier_B(100,2)
	create_soldier_B(100,2)
	create_soldier_B(100,2) 
	create_soldier_B(100,2)
		
	return [armyA, armyB]

func create_soldier_A(stamina, hp): 
	var swordsman = Swordsman.instance()
	swordsman.hp = hp
	swordsman.stamina = stamina
	swordsman.order_number = army_a_number
	swordsman.display_name = "A" + str(army_a_number)
	swordsman.position = Vector2(armyAxSpawnPos-distance_between_soldiers*(army_a_number-1),army_height)
	swordsman.expected_x_position = armyAxIntendedPos-distance_between_soldiers*(army_a_number-1)
	swordsman.set_sprite_idle()
	armyA.add_soldier(swordsman)
	army_a_number = army_a_number + 1
	
func create_soldier_B(stamina, hp): 
	var swordsman = Swordsman.instance()
	swordsman.hp = hp
	swordsman.stamina = stamina
	swordsman.order_number = army_b_number
	swordsman.display_name = "B" + str(army_b_number)
	swordsman.position = Vector2(armyBxSpawnPos+distance_between_soldiers*(army_b_number-1),army_height)
	swordsman.expected_x_position = armyBxIntendedPos+distance_between_soldiers*(army_b_number-1)
	swordsman.set_sprite_idle()
	swordsman.face_left()
	armyB.add_soldier(swordsman)
	army_b_number = army_b_number + 1

func create_archer_A(stamina, hp): 
	var archer = Archer.instance()
	archer.hp = hp
	archer.stamina = stamina
	archer.order_number = army_a_number
	archer.display_name = "A" + str(army_a_number)
	archer.position = Vector2(armyAxSpawnPos-distance_between_soldiers*(army_a_number-1),army_height)
	archer.expected_x_position = armyAxIntendedPos-distance_between_soldiers*(army_a_number-1)
	archer.set_sprite_idle()
	armyA.add_soldier(archer)
	army_a_number = army_a_number + 1
	
func create_archer_B(stamina, hp): 
	var archer = Archer.instance()
	archer.hp = hp
	archer.stamina = stamina
	archer.order_number = army_b_number
	archer.display_name = "B" + str(army_b_number)
	archer.position = Vector2(armyBxSpawnPos+distance_between_soldiers*(army_b_number-1),army_height)
	archer.expected_x_position = armyBxIntendedPos+distance_between_soldiers*(army_b_number-1)
	archer.set_sprite_idle()
	archer.face_left()
	armyB.add_soldier(archer)
	army_b_number = army_b_number + 1
