extends Node2D

const walk_speed = 100
const base_anim_speed = 1
const attack_distance = 32

const damage_time = 0.3
const attack_cycle_time = 1

const damage_amount = 5

signal deal_damage(amount) 

var time_to_next_attack = 0
var has_damaged = false

enum Action {WALK, FIGHT, IDLE} 

var action = Action.WALK
var is_player_near = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("walk")
	$AnimatedSprite.speed_scale = 1

func _process(delta):
	if action == Action.WALK:
		position.x -= walk_speed*delta
	if action == Action.FIGHT: 
		time_to_next_attack -= delta
		if time_to_next_attack <= (attack_cycle_time - damage_time) and not has_damaged: 
			has_damaged = true
			emit_signal("deal_damage", damage_amount)
		if time_to_next_attack <= 0: 
			attack()

func is_near_player(is_player_left): 
	if action != Action.FIGHT: 
		is_player_near = true
		action = Action.FIGHT
		attack()

func attack(): 
	time_to_next_attack = attack_cycle_time
	$AnimatedSprite.play("attack")
	$AnimatedSprite.speed_scale = 1
	has_damaged = false

func is_not_near_player():
	if action != Action.WALK: 
		action = Action.WALK
		is_player_near = false

func get_attack_range(): 
	return attack_distance

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "attack": 
		if action == Action.WALK: 
			$AnimatedSprite.play("walk")
			$AnimatedSprite.speed_scale = base_anim_speed
		else: 
			$AnimatedSprite.play("idle")
		$AnimatedSprite.speed_scale = base_anim_speed
		
