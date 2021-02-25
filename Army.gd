extends Node

var soldiers = []
var display_name = "display name"

# Should only be done once with any given soldier
func add_soldier(soldier): 
	soldiers.append(soldier)
	$ArmyLocator.add_soldier(soldier)

func move_soldier_to_back(): 
	var soldier = soldiers.pop_front()
	soldiers.append(soldier)

func set_all_soldiers_idle(): 
	for soldier in soldiers: 
		soldier.set_sprite_idle()

func size(): 
	return soldiers.size()

func front(): 
	return soldiers.front()

func kill_front_soldier(): 
	var front_soldier = soldiers.pop_front()
	# TODO remove from the army locator - add it to main? 
	front_soldier.set_sprite_dead()
	front_soldier.position.y += randi()%10-5
	print(front_soldier.display_name + " IS DEAD")
