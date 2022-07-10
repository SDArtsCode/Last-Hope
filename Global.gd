extends Node

var root: Node

var player: Node

var inventory_controller: Node

var info_log: Node

var max_inventory: float = 10.0

var curr_inventory: float = 0.0

var items: Dictionary = {
	"scrap": {"name": "Scrap", "volume": 0.2, "stored": 0},
	"power_cell": {"name": "Power Cell", "volume": 1.0, "stored": 0},
	"wiring": {"name": "Wiring", "volume": 0.1, "stored": 0},
	"sensor": {"name": "Sensor", "volume": 3.0, "stored": 0},
	"energy_core": {"name": "Energy Core", "volume": 4.0, "stored": 0},
	"blueprint": {"name": "Blueprint", "volume": 0.1, "stored": 0, "type": []}} # This should be last

func change_item_count(item: String, change: int):
	if curr_inventory + items[item]["volume"] * change <= max_inventory and items[item]["stored"] + change >= 0:
		items[item]["stored"] += change
		inventory_controller.update_inventory()
		return true
	elif curr_inventory + items[item]["volume"] * change > max_inventory:
		send("Inventory full!", "red")
		return false
	
func send(info: String, color: String):
	info_log.Update(info, color)
	
func get_base_name(id: String):
	var count = 0
	for item in items.values():
		if item["name"] == id:
			return items.keys()[count]
		count += 1
