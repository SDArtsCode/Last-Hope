extends Sprite

var upgrades: Array
var to_add: Array
var module_type = "primary_arm"
var ytarg = 0.0
var selected = -10
var count = 0

const GAP = 38

onready var slider = $Title2/Move
onready var upgrade_labels = preload("res://Scenes/UpgradeLabels.tscn")
onready var module_labels = preload("res://Scenes/module.tscn")

func _ready():
	Global.outfitting_menu = self
	update_ui()

class MyCustomSorter:
	static func sort_decending(a, b):
		if a[1] > b[1]:
			return true
		return false


func update_ui():
	for child in $Title1/VBoxContainer.get_children() + $Title2/Move/VBoxContainer.get_children():
		if child.name != "Spacer":
			child.queue_free()
	for blueprint in Global.blueprints.keys():
		if Global.blueprints[blueprint]["stats"]["type"] == "upgrade":
			var ulinst = upgrade_labels.instance()
			ulinst.get_node("under").value = Global.blueprints[blueprint]["stats"]["max"]
			ulinst.get_node("over").value = (Global.player_parts[blueprint] - Global.blueprints[blueprint]["stats"]["baseval"])/Global.blueprints[blueprint]["stats"]["effect"]
			ulinst.text = "\n" + Global.blueprints[blueprint]["name"] + ": \n"
			$Title1/VBoxContainer.add_child(ulinst)
		
	to_add.clear()
	for blueprint in Global.owned_modules:
		print(blueprint)
		var type = Global.blueprints[blueprint]["stats"]["type"]
		match module_type:
			"primary_arm":
				$Title2.text = "Primary Weapon"
				match type:
					"basic_melee":
						to_add.append([blueprint, "DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["swing_speed"], 0.1))])
						
					"basic_gun":
						to_add.append([blueprint, "DPS: " + str(stepify((Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["shoot_speed"])*Global.blueprints[blueprint]["stats"]["shots_per_click"], 0.1))])
					
					"close_melee":
						to_add.append([blueprint, "DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])])
					
					"laser_gun":
						to_add.append([blueprint, "DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])])
			
			"secondary_arm":
				$Title2.text = "Secondary Weapon"
				match type:
					"basic_melee":
						to_add.append([blueprint, "DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["swing_speed"], 0.1))])
						
					"basic_gun":
						to_add.append([blueprint, "DPS: " + str(stepify((Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["shoot_speed"])*Global.blueprints[blueprint]["stats"]["shots_per_click"], 0.1))])
					
					"close_melee":
						to_add.append([blueprint, "DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])])
					
					"laser_gun":
						to_add.append([blueprint, "DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])])
			
			"legs":
				$Title2.text = "Leg Modules"
				match type:
					"jump":
						to_add.append([blueprint, "JUMP"])
					
					"dash":
						to_add.append([blueprint, "DASH"])
			
			"utility":
				$Title2.text = "Utility Modules"
				match type:
					"flashlight":
						to_add.append([blueprint, "VISION"])
					
					"night_vision":
						to_add.append([blueprint, "VISION"])
					
					"scraper":
						to_add.append([blueprint, "SCRAP"])
	count = 0
	to_add.sort_custom(MyCustomSorter, "sort_decending")
	for segment in to_add:
		var mlinst = module_labels.instance()
		mlinst.get_node("Module").text = "        " + Global.blueprints[segment[0]]["name"] + " (" + segment[1] + ")" 
		mlinst.get_node("Module/AnimatedSprite").frame = Global.blueprints.keys().find(segment[0])
		mlinst.position.y += GAP*count
		mlinst.index = count
		$Title2/Move/VBoxContainer.add_child(mlinst)
		count += 1

func _process(delta):
	if selected == -10:
		modulate = Color(0.5, 0.5, 0.5)
	ytarg = -GAP*selected
	slider.position.y += (ytarg-slider.position.y)*delta*5

func _input(event):
	if selected == -10 and Global.blueprint_up and (event.is_action_pressed("up") or event.is_action_pressed("down") or event.is_action_pressed("drop_mode")):
		selected = 0
		modulate = Color(1, 1, 1)
		Global.selected = -2
		
	if event.is_action_pressed("up") and selected > 0 and Global.blueprint_up:
		selected -= 1
#		ytarg += GAP
		
	if event.is_action_pressed("down") and selected < count-1 and Global.blueprint_up:
		selected += 1
#		ytarg -= GAP
		
	if event.is_action_pressed("drop_mode") and Global.blueprint_up:
		selected = 0
		slider.position.y = 0
		match module_type: 
			"primary_arm": module_type = "secondary_arm"
			"secondary_arm": module_type = "legs"
			"legs": module_type = "utility"
			"utility": module_type = "primary_arm"
		update_ui()
	
	if event.is_action_pressed("select") and selected >= 0 and Global.blueprint_up:
		Global.transition()
		yield(get_tree().create_timer(1.0), "timeout")
		if module_type == "legs":
			Global.player_parts[module_type].append(to_add[selected][0])
			Global.owned_modules.erase(to_add[selected][0])
		else:
			if Global.player_parts[module_type].empty():
				Global.player_parts[module_type] = to_add[selected][0]
				Global.owned_modules.erase(to_add[selected][0])
			else:
				var temp = Global.player_parts[module_type]
				Global.player_parts[module_type] = to_add[selected][0]
				Global.owned_modules.erase(to_add[selected][0])
				Global.owned_modules.append(temp)
		update_ui()
		yield(get_tree().create_timer(1.0), "timeout")
		Global.transition()
