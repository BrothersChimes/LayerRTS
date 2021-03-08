extends Node

var soldiers = []
var display_name = "display name"
var distance_between_soldiers = 0

var is_facing_right = true

func _ready():
	$ArmyLocator/NameLabel.text = display_name

# Should only be done once with any given soldier
func add_soldier(soldier): 
	soldiers.append(soldier)
	$SoldierHolder.add_soldier(soldier)

# TODO sort this by moving the front guy to where he needs to be
# rather than moving the whole army around?

class SoldierSorter:
	static func sort_ascending(soldier1, soldier2):
		if soldier1.stamina > soldier2.stamina: 
			return true
		elif soldier1.stamina == soldier2.stamina: 
			if soldier1.hp > soldier2.hp:
				return true
			elif soldier1.hp == soldier2.hp: 
				if soldier1.order_number < soldier2.order_number: 
					return true
		return false
	
func sort_soldiers(): 
	soldiers.sort_custom(SoldierSorter, "sort_ascending")

func cycle_soldiers(): 
	var i = 0
	for soldier in soldiers: 
		var x_shift
		if is_facing_right: 
			x_shift = 0 -distance_between_soldiers*i
		else: 
			x_shift = distance_between_soldiers*i
		soldier.expected_x_position = $ArmyLocator.position.x + x_shift
		i += 1

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

func set_x_location(new_x_location): 
	$ArmyLocator.position.x = new_x_location

func set_location(new_location): 
	$ArmyLocator.position = new_location

func advance(how_far): 
	var x_shift
	if is_facing_right: 
		x_shift = 0 + distance_between_soldiers
	else: 
		x_shift = 0 - distance_between_soldiers
	$ArmyLocator.position.x = $ArmyLocator.position.x + x_shift
	
func retreat(how_far): 
	var x_shift
	if is_facing_right: 
		x_shift = 0 - distance_between_soldiers
	else: 
		x_shift = 0 + distance_between_soldiers
	$ArmyLocator.position.x = $ArmyLocator.position.x + x_shift
