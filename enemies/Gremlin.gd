extends Node2D

var state
var states

var GremlinWalk = preload("../enemies/GremlinWalk.tscn")
var GremlinBattle = preload("../enemies/GremlinBattle.tscn")
var GremlinDie = preload("../enemies/GremlinDie.tscn")

func _init():
	states = {
		"battle": GremlinBattle,
		"die": GremlinDie,
		"walk": GremlinWalk
}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state("walk")

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = get_state(new_state_name).instance()
	state.setup(funcref(self, "change_state"), $AnimatedSprite, self)
	state.name = "current_state"
	add_child(state)

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " in state factory!")
		
		
