extends Node2D

var state
var states

var PlayerMarch = preload("../player/PlayerMarch.tscn")
var PlayerBattle = preload("../player/PlayerBattle.tscn")

signal player_attacking(damage, is_left)
signal toggle_build()

func _init():
	states = {
		"march": PlayerMarch,
		"battle": PlayerBattle
	}

# Called when the node enters the scene tree for the first time.
func _ready():
	change_state("march")
	$ManaBar.set_value(0)

func change_state(new_state_name):
	if state != null:
		state.queue_free()
	state = get_state(new_state_name).instance()
	state.setup(funcref(self, "change_state"), $PlayerSprite, $HealthBar, $ManaBar, self)
	state.name = "current_state"
	add_child(state)

func get_state(state_name):
	if states.has(state_name):
		return states.get(state_name)
	else:
		printerr("No state ", state_name, " in state factory!")


func _on_PlayerSprite_animation_finished():
	state._on_PlayerSprite_animation_finished()
