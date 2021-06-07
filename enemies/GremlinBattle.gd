extends Node2D

const base_anim_speed = 1
const attack_distance = 20

const damage_time = 0.3
const attack_cycle_time = 1

const damage_amount = 5

signal deal_damage(amount) 
signal dies(this)

export var display_name = ""
signal exit_battle(this)

var time_to_next_attack = 0
var has_damaged = false

var health = 100
var max_health = 100
const health_recharge = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite.play("attack")
	$AnimatedSprite.speed_scale = 1
	
func _process(delta):
	health = clamp(max_health, 0, health + health_recharge*delta)
	$HealthBar.set_value(health/max_health*100)
	if health < 100: 
		$HealthBar.visible = true
	else: 
		$HealthBar.visible = false
	
	# IF IS IN BATTLE do battle action
	# IF IS OUT OF BATTLE do out of battle action
	#if action == Action.FIGHT: 
	time_to_next_attack -= delta
	if time_to_next_attack <= (attack_cycle_time - damage_time) and not has_damaged: 
		has_damaged = true
		emit_signal("deal_damage", damage_amount)
	if time_to_next_attack <= 0: 
		attack()
	
func is_not_near_battle():
	pass 
#	print("Enemy (me) " + display_name + " exited battle")
#	var walk_instance = GremlinWalk.instance()
#	walk_instance.position = position
#	emit_signal("exit_battle", self, walk_instance)
		
func attack(): 
	time_to_next_attack = attack_cycle_time
	$AnimatedSprite.play("attack")
	$AnimatedSprite.speed_scale = 1
	has_damaged = false

func take_damage(damage): 
	health -= damage
	if health <= 0:
		die()

func die(): 
	emit_signal("dies", self)
	queue_free()

func is_not_near_player():
	print("Enemy (me) " + display_name + " exited battle")
	emit_signal("exit_battle", self)

func get_attack_range(): 
	return attack_distance

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "attack": 
		pass # TODO HUH?!
