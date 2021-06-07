extends Node2D

const walk_speed = 100
const base_anim_speed = 1
const attack_distance = 20

signal deal_damage(amount) 
signal dies(this, death_instance)
signal near_player(this, battle_instance)
signal enter_battle(this)

export var display_name = ""

var time_to_next_attack = 0
var has_damaged = false

var health = 100
var max_health = 100
const health_recharge = 1

enum Action {WALK, IDLE} 

var action = Action.WALK
var is_player_near = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("walk")
	$AnimatedSprite.speed_scale = 1

func set_display_name(new_name): 
	display_name = new_name
	
func _process(delta):
	health = clamp(max_health, 0, health + health_recharge*delta)
	$HealthBar.set_value(health/max_health*100)
	if health < 100: 
		$HealthBar.visible = true
	else: 
		$HealthBar.visible = false
	
	# IF IS IN BATTLE do battle action
	# IF IS OUT OF BATTLE do out of battle action
	if action == Action.WALK:
		position.x -= walk_speed*delta
		
#	if action == Action.FIGHT: 
#		time_to_next_attack -= delta
#		if time_to_next_attack <= (attack_cycle_time - damage_time) and not has_damaged: 
#			has_damaged = true
#			emit_signal("deal_damage", damage_amount)
#		if time_to_next_attack <= 0: 
#			attack()

func is_near_player(is_player_left): 
	emit_signal("near_player", self)
	queue_free()

func is_near_battle():
	pass
#	if not is_in_battle: 
#		is_in_battle = true
#		print("Enemy (me) " + display_name + " ENTERED battle")
#		emit_signal("enter_battle", self)
#		if action != Action.FIGHT and action != Action.DIE: 
#			action = Action.FIGHT
			# emit_signal("enter_battle", self)
			# print(display_name + " IS NEAR BATTLE")
	
func is_not_near_battle(): 
	pass
#	if is_in_battle: 
#		is_in_battle = false
#		print("Enemy (me) " + display_name + " exited battle")
#		emit_signal("exit_battle", self)
		
#func attack(): 
#	time_to_next_attack = attack_cycle_time
#	$AnimatedSprite.play("attack")
#	$AnimatedSprite.speed_scale = 1
#	has_damaged = false

func take_damage(damage): 
	health -= damage
	if health <= 0:
		die()

func die(): 
	emit_signal("dies", self)
	queue_free()

func is_not_near_player():
	pass
#	if action != Action.WALK and action != Action.DIE: 
#		action = Action.WALK
#		#emit_signal("exit_battle", self)
#		is_player_near = false

func get_attack_range(): 
	return attack_distance

