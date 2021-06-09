extends Node2D

class_name GremlinState

var change_state
var animated_sprite
var persistent_state
var health_bar
var velocity = 0

func setup(change_state, animated_sprite, health_bar, persistent_state):
	self.change_state = change_state
	self.animated_sprite = animated_sprite
	self.health_bar = health_bar
	self.persistent_state = persistent_state
