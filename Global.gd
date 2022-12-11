extends Node

var root: Node

var player: Node

var inventory_controller: Node

var info_log: Node

var outfitting_menu: Node

var transition_nodes: Array

var time: float = 200
const CYCLE_LEN: float = 600.0

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
	"blueprint": {"name": "Blueprint", "volume": 0.1, "stored": 0, "bunker": "", "type": []} # This should be last 
	} 

#UNLOCKED MODULES
var blueprints: Dictionary = {
	#weapons
	"baseball_bat": {"stats": {"type": "basic_melee", "damage": 15, "swing_speed": 1.0, "length": 1.0}, 
	"name": "Baseball Bat", "has_blueprint": true, "cost": [5, 2, 3, 0, 0], "description": "Bludgeons enemies like... concrete"},
	
	"scythe": {"stats": {"type": "basic_melee", "damage": 10, "swing_speed": 0.4, "length": 0.75}, 
	"name": "Scythe", "has_blueprint": false, "cost": [20, 1, 2, 0, 0], "description": "ADD DESCRIPTION HERE"},
	
	"plasma_sword": {"stats": {"type": "basic_melee", "damage": 50, "swing_speed": 1.5, "length": 1.5}, 
	"name": "Plasma Sword", "has_blueprint": false, "cost": [10, 5, 5, 0, 1], "description": "Condences energy into plasma, slicing through enemies like butter"},
	
	"chainsaw": {"stats": {"type": "close_melee", "dps": 60, "length": 0.5}, 
	"name": "Hyper Chainsaw", "has_blueprint": false, "cost": [30, 10, 5, 0, 1], "description": "ADD description HERE"},
	
	"pistol": {"stats": {"type": "basic_gun", "damage": 10, "shoot_speed": 1.0, "shots_per_click": 1, "spacing": 0.5, "ammo": 6, "accuracy": 0}, 
	"name": "Laser Pistol", "has_blueprint": true, "cost": [5, 1, 2, 0, 0], "description": "Basic weapon, fairly weak"},
	
	"rifle": {"stats": {"type": "basic_gun", "damage": 5, "shoot_speed": 1.0, "shots_per_click": 4, "spacing": 0.1, "ammo": 10, "accuracy": 1},
	"name": "Laser Rifle", "has_blueprint": false, "cost": [10, 3, 2, 0, 0], "description": "Burst fire weapon, deals more damage than the laser pistol"},
	
	"shotgun": {"stats": {"type": "basic_gun", "damage": 3, "shoot_speed": 1.5, "shots_per_click": 20, "spacing": 0.001, "ammo": 4, "accuracy": 7.5},
	"name": "The Sawdon", "has_blueprint": false, "cost": [20, 4, 6, 0, 1], "description": "Shoots in a cone shape, deals massive damage when close"},
	
	"laser": {"stats": {"type": "laser_gun", "dps": 40},
	"name": "The Eliminator 9000", "has_blueprint": false, "cost": [30, 8, 10, 1, 2], "description": "Fires a solid laser to evaporate your foes"},
	
	# modules
	"scrapper": {"stats": {"type": "scrapper"}, "name": "Scrapper Module", "has_blueprint": false, "cost": [30, 0, 2, 4, 1], "description": "Increases scrap dropped by 50%"},
	"battery": {"stats": {"type": "upgrade", "effect": 100, "baseval": 100, "max": 5}, "name": "Battery Capacity", "has_blueprint": true, "cost": [0, 0, 2, 0, 1], "description": "Increases battery capacity"},
	"storage": {"stats": {"type": "upgrade", "effect": 10, "baseval": 10, "max": 5}, "name": "Storage Space", "has_blueprint": true, "cost": [20, 0, 2, 1, 0], "description": "Increases storage space"},
	"health": {"stats": {"type": "upgrade", "effect": 50, "baseval": 100, "max": 5}, "name": "Armor", "has_blueprint": true, "cost": [30, 0, 0, 0, 0], "description": "Increases hipoints"},
	"damage": {"stats": {"type": "upgrade", "effect": 50, "baseval": 100, "max": 5}, "name": "Damage", "has_blueprint": true, "cost": [30, 0, 0, 0, 0], "description": "Increases damage"},
	"reload": {"stats": {"type": "upgrade", "effect": 50, "baseval": 100, "max": 5}, "name": "Reload", "has_blueprint": true, "cost": [30, 0, 0, 0, 0], "description": "Increases reload speed"},
	
	#movement modules
	"double_jump": {"stats": {"type": "double_jump"}, "name": "Double Jump Module", "has_blueprint": false, "cost": [10, 2, 2, 0, 0], "description": "Allows the user to jump twice."},
	"dash": {"stats": {"type": "dash"}, "name": "Dash Module", "has_blueprint": false, "cost": [15, 1, 2, 0, 0], "description": "Allows the user to dash."},
	"zipline": {"stats": {"type": "zipline"}, "name": "Zipline Module", "has_blueprint": false, "cost": [15, 1, 2, 0, 0], "description": "Allows the user to use zipline points."},

	}

#OWNED MODULES
var owned_modules: Array = ["baseball_bat", "plasma_sword", "chainsaw", "pistol", "rifle", "shotgun", "laser", "double_jump", "dash", "scrapper"]

#EQUIPPED MODULES
var upgrades: Dictionary = {
	"weapons": ["scythe", "pistol"],
	"movement": ["double_jump", "dash", "zipline"],
	"modules": ["scrapper"],
	"power_capacity": 300,
	"battery": 100,
	"speed": 200,
	"storage": 10.0,
	"health": 100
}

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
	if curr_inventory + items[item]["volume"] * change <= upgrades["storage"] and items[item]["stored"] + change >= 0:
		items[item]["stored"] += change
		inventory_controller.update_inventory()
		return true
	elif curr_inventory + items[item]["volume"] * change > upgrades["storage"]:
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
