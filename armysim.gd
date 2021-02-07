extends Node

func _ready():
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	var armies = armyCreator.create_soldiers_for_test() 
	add_child(armies[0])
	add_child(armies[1])
	armyCombatSim.start_combat_with_armies(armies[0], armies[1])
