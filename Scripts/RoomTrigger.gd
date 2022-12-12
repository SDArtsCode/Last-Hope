extends Area2D

export (int) var room_index = 0
export (int) var door_index = 0

func _on_RoomTrigger_area_entered(area):
	if area.is_in_group("Player"):
		
		
		pass
	pass
