extends Node2D

export var gradient: Gradient
onready var parent = get_node("../../")
var index = 0

func _process(delta):
	modulate = Color(gradient.interpolate((parent.position.y+position.y+25)/300.0))
