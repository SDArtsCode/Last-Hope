extends Entity2D


export (Array, String, "scrap", "power_cell", "wiring", "sensor", "energy_core") var parts_to_drop
export (float, 0.0, 20.0) var volume_of_parts_dropped = 4.0
var cur_vol_of_parts : float = 0.0
var cur_parts_to_drop : Array

const MAX_DROP_SPEED : float = 10.0

func _ready():
	randomize()
	connect("OnEntityDead", self, "Entity2D_OnEntityDead")
	if parts_to_drop.size() > 0:
		while cur_vol_of_parts < volume_of_parts_dropped:
			parts_to_drop.shuffle()
			cur_parts_to_drop.append(parts_to_drop[0])
			print(parts_to_drop)
			cur_vol_of_parts += Global.items[parts_to_drop[0]]["volume"]
			print("Vol: " + str(cur_vol_of_parts) + ", Part: " + parts_to_drop[0])
		print("parts successfully calculated")
	
func Entity2D_OnEntityDead():
	for item_name in cur_parts_to_drop:
		var new_item : Item2D = Global.ITEM_PRELOAD.instance()
		new_item.item_name = item_name
		get_tree().get_current_scene().add_child(new_item)
		new_item.global_position = global_position
		new_item.apply_central_impulse(Vector2((randf() - 0.5) * 2 * MAX_DROP_SPEED, (randf() - 0.5) * 2 * MAX_DROP_SPEED))
	queue_free()
