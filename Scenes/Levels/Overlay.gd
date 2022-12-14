extends Node

func _ready():
	for n in get_children():
		n.visible = true
