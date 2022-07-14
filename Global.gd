extends Node

var root: Node

var player: Node

var inventory_controller: Node

var info_log: Node

var outfitting_menu: Node

var transition_nodes: Array

var time: float = 0.0
const CYCLE_LEN: float = 15.0

var curr_inventory: float = 0.0

var selected = -1
var entered = false
var can_enter = false

var blueprint_up = false

const COST_KEY = ["scrap", "power_cell", "wiring", "sensor", "energy_core"]

var items: Dictionary = {
	"scrap": {"name": "Scrap", "volume": 0.2, "stored": 0, "bunker": 1},
	"power_cell": {"name": "Power Cell", "volume": 1.0, "stored": 0, "bunker": 1},
	"wiring": {"name": "Wiring", "volume": 0.1, "stored": 0, "bunker": 1},
	"sensor": {"name": "Sensor", "volume": 3.0, "stored": 0, "bunker": 1},
	"energy_core": {"name": "Energy Core", "volume": 4.0, "stored": 0, "bunker": 1},
	"blueprint": {"name": "Blueprint", "volume": 0.1, "stored": 0, "bunker": "fuck", "type": []} # This should be last
} 

var blueprints: Dictionary = {
	# I would like to appologize in advance, but im like 90% sure this is not dumb
	"energy_sword": {"stats": {"type": "basic_melee", "damage": 15, "swing_speed": 1.0, "length": 1.0}, 
	"name": "Energy Sword", "has_blueprint": true, "cost": [5, 2, 3, 0, 0], "discription": "Slices through enemies like... concrete"},
	
	"sythe": {"stats": {"type": "basic_melee", "damage": 10, "swing_speed": 0.4, "length": 0.75}, 
	"name": "Sythe", "has_blueprint": false, "cost": [20, 1, 2, 0, 0], "discription": "ADD DISCRIPTION HERE"},
	
	"plasma_sword": {"stats": {"type": "basic_melee", "damage": 50, "swing_speed": 1.5, "length": 1.5}, 
	"name": "Plasma Sword", "has_blueprint": false, "cost": [10, 5, 5, 0, 1], "discription": "Condences energy into plasma, slicing through enemies like butter"},
	
	"chainsaw": {"stats": {"type": "close_melee", "dps": 60, "length": 0.5}, 
	"name": "Hyper Chainsaw", "has_blueprint": false, "cost": [30, 10, 5, 0, 1], "discription": "ADD DISCRIPTION HERE"},
	
	"pistol": {"stats": {"type": "basic_gun", "damage": 10, "shoot_speed": 1.0, "shots_per_click": 1, "spacing": 0.5}, 
	"name": "Laser Pistol", "has_blueprint": true, "cost": [5, 1, 2, 0, 0], "discription": "Basic weapon, fairly weak"},
	
	"rifle": {"stats": {"type": "basic_gun", "damage": 5, "shoot_speed": 1.0, "shots_per_click": 4, "spacing": 0.1},
	"name": "Laser Rifle", "has_blueprint": false, "cost": [10, 3, 2, 0, 0], "discription": "Burst fire weapon, deals more damage than the laser pistol"},
	
	"shotgun": {"stats": {"type": "basic_gun", "damage": 3, "shoot_speed": 0.2, "shots_per_click": 20, "spacing": 0.001},
	"name": "The Sawdon", "has_blueprint": false, "cost": [20, 4, 6, 0, 1], "discription": "Shoots in a cone shape, deals massive damage when close"},
	
	"laser": {"stats": {"type": "laser_gun", "dps": 40},
	"name": "The Eliminator 9000", "has_blueprint": false, "cost": [30, 8, 10, 1, 2], "discription": "Fires a solid laser to evaporate your foes"},
	
	# modules
	"flashlight": {"stats": {"type": "flashlight"}, "name": "Flashlight Module", "has_blueprint": false, "cost": [5, 1, 2, 0, 0], "discription": "Lights your way at night"},
	"night_vision": {"stats": {"type": "night_vision"}, "name": "Night Vision Module", "has_blueprint": false, "cost": [10, 2, 5, 2, 1], "discription": "Allows the user to see more at night"},
	"scraper": {"stats": {"type": "scraper"}, "name": "Scraper Module", "has_blueprint": false, "cost": [30, 0, 2, 4, 1], "discription": "Increases scrap dropped by 50%"},
	"jump": {"stats": {"type": "jump"}, "name": "Jump Leg Module", "has_blueprint": false, "cost": [10, 2, 2, 0, 0], "discription": "Allows the user to jump"},
	"dash": {"stats": {"type": "dash"}, "name": "Dash Leg Module", "has_blueprint": false, "cost": [15, 1, 2, 0, 0], "discription": "Allows the user to dash"},
	
	# upgrades
	"battery": {"stats": {"type": "upgrade", "effect": 100, "baseval": 100, "max": 5}, "name": "Battery Capacity", "has_blueprint": true, "cost": [0, 0, 2, 0, 1], "discription": "Increases battery capacity"},
	"speed": {"stats": {"type": "upgrade", "effect": 100, "baseval": 200, "max": 3}, "name": "Speed", "has_blueprint": true, "cost": [10, 2, 2, 0, 0], "discription": "Increases movement speed, with no cost to battery"},
	"storage": {"stats": {"type": "upgrade", "effect": 10, "baseval": 10, "max": 5}, "name": "Storage Space", "has_blueprint": true, "cost": [20, 0, 2, 1, 0], "discription": "Increases storage space"},
	"health": {"stats": {"type": "upgrade", "effect": 50, "baseval": 100, "max": 5}, "name": "Armor", "has_blueprint": true, "cost": [30, 0, 0, 0, 0], "discription": "Increases hipoints"}
}

var player_parts: Dictionary = {
	"utility": "",
	"legs": [],
	"primary_arm": "pistol",
	"secondary_arm": "",
	"battery": 100,
	"speed": 200,
	"storage": 10.0,
	"health": 100
}

var owned_modules: Array = []

#var upgrades: Dictionary = {
#	"battery": {"name": "Battery Capacity", "effect": 100, "cost": [0, 0, 2, 0, 1], "max": 5},
#	"speed": {"name": "Speed", "effect": 100, "cost": [10, 2, 2, 0, 0], "max": 3},
#	"storage": {"name": "Storage Space", "effect": 10, "cost": [20, 0, 2, 1, 0], "max": 5},
#	"health": {"name": "Armor", "effect": 50, "cost": [30, 0, 0, 0, 0], "max": 5}
#}




const ITEM_PRELOAD = preload("res://Scenes/Item.tscn")
const BULLET_PRELOAD = preload("res://Weapons/Bullet/Bullet.tscn")

var timer = 0.0
func _process(delta):
	timer += delta
	if timer >= 1.0:
		time += 1
		timer -= 1.0
	if time >= CYCLE_LEN:
		time = 0


func change_item_count(item: String, change: int):
	if curr_inventory + items[item]["volume"] * change <= player_parts["storage"] and items[item]["stored"] + change >= 0:
		items[item]["stored"] += change
		inventory_controller.update_inventory()
		return true
	elif curr_inventory + items[item]["volume"] * change > player_parts["storage"]:
		send("Inventory full!", "red")
		return false

func send(info: String, color: String):
	info_log.Update(info, color)

# in case we wanna change the transition
var in_: bool = false
func transition():
	for transition_node in transition_nodes:
		if is_instance_valid(transition_node):
			if in_:
				in_ = false
				transition_node.play("fade")
			else:
				in_ = true
				transition_node.play_backwards("fade")

func get_base_name(id: String):
	var count = 0
	for item in items.values():
		if item["name"] == id:
			return items.keys()[count]
		count += 1
