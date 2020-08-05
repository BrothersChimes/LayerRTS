extends Node2D
var anim

func _ready(): 
	anim = get_node("AnimatedSprite")

func set_is_flipped(new_flip): 
	anim.set_flip_h(new_flip)

func begin_attack():
	anim.play("attack")

func begin_walk(): 
	anim.play("run")

func begin_idle():
	anim.play("idle")
