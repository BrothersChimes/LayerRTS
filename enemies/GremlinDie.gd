extends Node2D

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.get_animation() == "die": 
		queue_free()
