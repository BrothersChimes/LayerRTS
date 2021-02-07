extends Node2D

var soldiers = []

func add_soldier(soldier): 
	soldiers.append(soldier)

func size(): 
	return soldiers.size()

func push_back(soldier): 
	soldiers.append(soldier)
	
func pop_front(): 
	return soldiers.pop_front()
	
func front(): 
	return soldiers.front()
