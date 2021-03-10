extends Node2D

const distance_between_soldiers = 32
var armies = []

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		for army in armies: 
			army.objective_x_position = get_global_mouse_position().x

func _ready():
	combat_sim()
	
func march_sim(): 
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyAxIntendedPos = armyCreator.armyAxSpawnPos
	var army = armyCreator.create_soldiers_for_march_test() 
	armies.append(army)
	add_child(army)
	
func combat_sim(): 
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyBxSpawnPos = 1000
	armyCreator.armyAxIntendedPos = 400
	armyCreator.armyBxIntendedPos = armyCreator.armyAxIntendedPos + distance_between_soldiers
	var armies = armyCreator.create_soldiers_for_combat_test() 
	add_child(armies[0])
	add_child(armies[1])
	armyCombatSim.start_combat_with_armies(armies[0], armies[1])
