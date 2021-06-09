extends GremlinState

const WALK_SPEED = 50

func _ready():
	animated_sprite.play("walk")
	
func _process(delta): 
	persistent_state.position.x -= WALK_SPEED*delta

func signal_player_pos(player_pos_x): 
	var is_left = true
	var enemy_pos_x = persistent_state.position.x
	var distance = 16
	if is_left and enemy_pos_x > player_pos_x: 
		if enemy_pos_x - player_pos_x <= distance:
			enter_battle()
	if not is_left and enemy_pos_x < player_pos_x: 
		if player_pos_x - enemy_pos_x <= distance:
			enter_battle()
			
func enter_battle(): 
	change_state.call_func("attack")
