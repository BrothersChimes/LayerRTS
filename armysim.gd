extends Node2D

const Army = preload("Army.tscn")

const distance_between_soldiers = 32
var armies = []

var combat_distance = 128

enum Status {MARCH, COMBAT}
var status = Status.MARCH

func _input(event):
	# Mouse in viewport coordinates.
	if event is InputEventMouseButton:
		# print("Clicked on: ",  get_global_mouse_position().x)
		for army in armies: 
			army.objective_x_position = get_global_mouse_position().x

func _ready():
	march_to_combat_sim()

func _process(delta): 
	if status == Status.MARCH: 
		if armies.size() == 2: 
			if abs(armies[0].x_position() - armies[1].x_position()) < combat_distance:
				armies[1].set_x_position(armies[0].x_position() + distance_between_soldiers) 
				status = Status.COMBAT
				$ArmyCombatSim.start_combat_with_armies(armies[0], armies[1])


func _on_army_removed(army): 
	armies.remove(armies.rfind(army))
	
func march_to_combat_sim():
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyAxIntendedPos = armyCreator.armyAxSpawnPos
	
	armyCreator.armyBxSpawnPos = 1000
	armyCreator.armyBxIntendedPos = armyCreator.armyBxSpawnPos + distance_between_soldiers
	
	armies = armyCreator.create_soldiers_for_march_to_combat_test()
	add_army(armies[0])
	add_army(armies[1])

func march_sim(): 
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyAxIntendedPos = armyCreator.armyAxSpawnPos
	armies = armyCreator.create_soldiers_for_march_test() 
	add_army(armies[0])
	
func combat_sim(): 
	status = Status.COMBAT
	var armyCombatSim = $ArmyCombatSim
	var armyCreator = $ArmyCreator
	armyCreator.distance_between_soldiers = distance_between_soldiers
	armyCreator.armyAxSpawnPos = $SoldierSpawnerLeft.position.x
	armyCreator.armyBxSpawnPos = 1000
	armyCreator.armyAxIntendedPos = 400
	armyCreator.armyBxIntendedPos = armyCreator.armyAxIntendedPos + distance_between_soldiers
	armies = armyCreator.create_soldiers_for_combat_test() 
	add_army(armies[0])
	add_army(armies[1])
	armyCombatSim.start_combat_with_armies(armies[0], armies[1])

func add_army(army): 
	add_child(army)
	army.connect("army_removed", self, "_on_army_removed")

