extends Node2D

var soldiers = []
var display_name = "display name"

func add_soldier_to_back(soldier): 
	soldiers.append(soldier)
	
func move_soldier_to_back(): 
	add_soldier_to_back(pop_front())

func size(): 
	return soldiers.size()
	
func pop_front(): 
	return soldiers.pop_front()
	
func front(): 
	return soldiers.front()

func kill_front_soldier(): 
	var front_soldier = pop_front()
	print(front_soldier.display_name + " IS DEAD")
