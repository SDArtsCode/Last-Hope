extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.last_door != -1:
		for door in $Doors.get_children():
			if door.door_index == Global.last_door:
				get_node("Player").global_position = door.global_position + door.relative_spawn
				break
