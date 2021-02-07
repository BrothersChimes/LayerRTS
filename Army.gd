extends Node

var soldiers = []
var display_name = "display name"

# Should only be done once with any given soldier
func add_soldier(soldier): 
	soldiers.append(soldier)
	$ArmyLocator.add_soldier(soldier)

func move_soldier_to_back(): 
	soldiers.append(soldiers.pop_front())

func size(): 
	return soldiers.size()
	
func front(): 
	return soldiers.front()

func kill_front_soldier(): 
	var front_soldier = soldiers.pop_front()
	# TODO remove from the army locator - add it to main? 
	print(front_soldier.display_name + " IS DEAD")
