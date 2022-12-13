extends Area2D

export (int) var room_index = 0
export (int) var door_index = 0
export (Vector2) var relative_spawn = Vector2()

func _on_RoomTrigger_body_entered(body):
	if body.is_in_group("Player"):
		Global.last_door = door_index
		get_tree().get_current_scene().switch_scene(room_index) # use scene_controller


