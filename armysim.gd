extends Node

const distance_between_soldiers = 32


func _ready():
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyBxSpawnPos = 1000
	armyCreator.armyAxIntendedPos = 400
	armyCreator.armyBxIntendedPos = armyCreator.armyAxIntendedPos + distance_between_soldiers
	var armies = armyCreator.create_soldiers_for_test() 
	add_child(armies[0])
	add_child(armies[1])
	armyCombatSim.start_combat_with_armies(armies[0], armies[1])
