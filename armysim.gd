extends Node

func _ready():
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	var armies = armyCreator.create_soldiers_for_test() 
	armyCombatSim.start_combat_with_armies(armies[0], armies[1])
