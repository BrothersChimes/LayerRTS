extends Node2D

signal register_units()

const ground_level = 162
var Builder = preload("../units/Builder.tscn")

var builders = []

func _ready():
	# create_builders()	
	pass
	
func create_builders():	
	var builder
	
	builder = Builder.instance()
	builder.position = Vector2(0, ground_level)
	builders.append(builder)
	add_child(builder)
	
	builder = Builder.instance()
	builder.position = Vector2(32, ground_level)
	builders.append(builder)
	add_child(builder)

	# Send the builders to the game controller
	emit_signal("register_units")
