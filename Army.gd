extends Node

signal army_removed(army) 

var soldiers = []
var display_name = "display name"
var distance_between_soldiers = 0
const SoldierType = preload("SoldierType.gd").SoldierType

var is_facing_right = true

var objective_x_position = 400
const position_delta = 4 
const march_speed = 100

enum Status {MARCH, COMBAT}
var status = Status.MARCH

func _ready():
	$ArmyLocator/NameLabel.text = display_name
	
func _process(delta): 
	if status == Status.MARCH: 
		if $ArmyLocator.position.x - objective_x_position > position_delta: 
			$ArmyLocator.position.x -= delta*march_speed
			is_facing_right = false
			march_soldiers()
	#		for soldier in soldiers:
	#			soldier.reposition()
			# is_walk_backwards = not is_facing_left
		elif objective_x_position - $ArmyLocator.position.x > position_delta:
			$ArmyLocator.position.x += delta*march_speed
			is_facing_right = true
			march_soldiers()
		else: 
			$ArmyLocator.position.x = objective_x_position
			stop_soldiers()

func x_position(): 
	return $ArmyLocator.position.x

func set_x_position(new_x_position): 
	$ArmyLocator.position.x = new_x_position

# Should only be done once with any given soldier
func add_soldier(soldier): 
	soldiers.append(soldier)
	$SoldierHolder.add_soldier(soldier)

func start_combat(): 
	status = Status.COMBAT
	for soldier in soldiers: 
		soldier.start_combat()

func end_combat(): 
	if soldiers.size() == 0: 
		remove_army()
	status = Status.MARCH
	for soldier in soldiers: 
		soldier.end_combat()

func remove_army(): 
	queue_free()
	emit_signal("army_removed", self)
# TODO sort this by moving the front guy to where he needs to be
# rather than moving the whole army around?

class SoldierSorter:
	static func sort_ascending(soldier1, soldier2):
		if soldier1.soldier_type == SoldierType.MELEE and soldier2.soldier_type == SoldierType.RANGED:
			return true
		if soldier2.soldier_type == SoldierType.MELEE and soldier1.soldier_type == SoldierType.RANGED:
			return false
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

func march_soldiers():
	var i = 0
	for soldier in soldiers: 
		var x_shift
		if is_facing_right: 
			x_shift = 0 -distance_between_soldiers*i
		else: 
			x_shift = distance_between_soldiers*i
		soldier.marched_to($ArmyLocator.position.x + x_shift, not is_facing_right)
		i += 1

func stop_soldiers():
	var i = 0
	for soldier in soldiers: 
		var x_shift
		if is_facing_right: 
			x_shift = 0 -distance_between_soldiers*i
		else: 
			x_shift = distance_between_soldiers*i
		soldier.stopped_at($ArmyLocator.position.x + x_shift, not is_facing_right)
		i += 1

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
		
func set_all_melee_soldiers_idle(): 
	var i = 0
	for soldier in soldiers: 
		if i == 0: 
			i += 1
			soldier.set_sprite_idle()
			continue
		if soldier.soldier_type == SoldierType.MELEE: 
			soldier.set_sprite_idle()

func set_all_ranged_soldiers_idle(): 
	var i = 0
	for soldier in soldiers: 
		if i == 0: 
			i += 1
			continue
		if soldier.soldier_type == SoldierType.RANGED: 
			soldier.set_sprite_idle()
			
func size(): 
	return soldiers.size()

func front(): 
	return soldiers.front()

func kill_soldier_at(location):
	var soldier_at_location = soldiers[location]
	soldiers.remove(location)
	soldier_at_location.set_sprite_dead()

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
