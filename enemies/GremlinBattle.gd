extends GremlinState

func _ready():
	animated_sprite.play("attack")

func signal_player_pos(player_pos_x): 
	var is_left = true
	var enemy_pos_x = persistent_state.position.x
	var distance = 16
	if is_left and enemy_pos_x > player_pos_x: 
		if enemy_pos_x - player_pos_x > distance:
			exit_battle()
	if not is_left and enemy_pos_x < player_pos_x: 
		if player_pos_x - enemy_pos_x > distance:
			exit_battle()
			
func exit_battle(): 
	change_state.call_func("walk")
