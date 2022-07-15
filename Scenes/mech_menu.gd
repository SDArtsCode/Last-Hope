extends Sprite

var upgrades: Array
var module_type = "arm"
var to_add: Array

const GAP = 128

onready var upgrade_labels = preload("res://Scenes/UpgradeLabels.tscn")
onready var module_labels = preload("res://Scenes/module.tscn")

func _ready():
	Global.outfitting_menu = self
	update_ui()

func update_ui():
	for child in $Title1/VBoxContainer.get_children():
		if child.name != "Spacer":
			child.queue_free()
	for blueprint in Global.blueprints.keys():
		if Global.blueprints[blueprint]["stats"]["type"] == "upgrade":
			var ulinst = upgrade_labels.instance()
			ulinst.get_node("under").value = Global.blueprints[blueprint]["stats"]["max"]
			ulinst.get_node("over").value = (Global.player_parts[blueprint] - Global.blueprints[blueprint]["stats"]["baseval"])/Global.blueprints[blueprint]["stats"]["effect"]
			ulinst.text = "\n" + Global.blueprints[blueprint]["name"] + ": \n"
			$Title1/VBoxContainer.add_child(ulinst)
		
	for blueprint in Global.owned_modules:
		var type = Global.blueprints[blueprint]["stats"]["type"]
		match module_type:
			"arm":
				match type:
					"basic_melee":
						to_add.append([blueprint, "DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["swing_speed"], 0.1))])
						
					"basic_gun":
						to_add.append([blueprint, "DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["shoot_speed"], 0.1))])
					
					"close_melee" or "laser_gun":
						to_add.append([blueprint, "DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])])
			
			"legs":
				match type:
					"jump":
						to_add.append([blueprint, "JUMP"])
					
					"dash":
						to_add.append([blueprint, "DASH"])
			
			"utility":
				match type:
					"flashlight":
						to_add.append([blueprint, "VISION"])
					
					"night_vision":
						to_add.append([blueprint, "VISION"])
					
					"scraper":
						to_add.append([blueprint, "SCRAP"])
	var count = 0
	for segment in to_add:
		var mlinst = module_labels.instance()
		mlinst.get_node("Module").text = "\n" + Global.blueprints[segment[0]]["name"] + " (" + segment[1] + ")\n\n" 
		mlinst.get_node("Module/AnimatedSprite").frame = Global.blueprints.keys().find(segment[0])
		mlinst.position.y += GAP*count
		$Title2/Move/VBoxContainer.add_child(mlinst)
		count += 1

func _input(event):
	if event.is_action_pressed("up"):
		pass
