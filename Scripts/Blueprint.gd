extends Node2D

var blueprint: String = "pistol"
var index = 0
var prev_select: bool = false
var played: bool = false

onready var mid = get_node("../../bg")
onready var anim = $good

func _ready():
	update_ui()

func update_ui():
	$Sprite2/Title.text = Global.blueprints[blueprint]["name"]
	$Sprite2/Description.text = Global.blueprints[blueprint]["description"]
	$Sprite.frame = Global.blueprints.keys().find(blueprint)
	var type = Global.blueprints[blueprint]["stats"]["type"]
	
	$Sprite2/Cost.modulate = Color(0.0, 1.0, 0.0)
	for mat in Global.COST_KEY:
		if Global.items[mat]["bunker"] < Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(mat)]:
			$Sprite2/Cost.modulate = Color(1.0, 0.0, 0.0)
			played = true
	$Sprite2/Cost.text = "- COST -\n"
	$Sprite2/Stats.text = "- STATS -\n"
	if played:
		for key in Global.COST_KEY:
			if Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)] != 0:
				$Sprite2/Cost.text += Global.items[key]["name"] + ": " + str(Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)]) + " (" + str(Global.items[key]["bunker"]) + ")\n"
	else:
		for key in Global.COST_KEY:
			if Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)] != 0:
				$Sprite2/Cost.text += Global.items[key]["name"] + ": " + str(Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)]) + "\n"
	
	match type:
		"basic_melee": # {"type": "basic_melee", "damage": 15, "swing_speed": 10, "length": 1.0}
			if Global.blueprints[blueprint]["stats"]["swing_speed"] != 1.0:
				$Sprite2/Stats.text += ("Damage: " + str(Global.blueprints[blueprint]["stats"]["damage"]) + "/hit\n" + 
										"Swing Speed: " + str(Global.blueprints[blueprint]["stats"]["swing_speed"]) + " hits/sec\n" +
										"DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["swing_speed"], 0.1)) + "\n" +
										"Size: " + str(Global.blueprints[blueprint]["stats"]["length"]) + "m")
			else:
				$Sprite2/Stats.text += ("Damage: " + str(Global.blueprints[blueprint]["stats"]["damage"]) + "/hit\nSwing Speed: 1.0/sec\n" +
										"Size: " + str(Global.blueprints[blueprint]["stats"]["length"]))
			
		"close_melee": # {"type": "close_melee", "dps": 60, "length": 0.75}
			$Sprite2/Stats.text += ("DPS: " + str(Global.blueprints[blueprint]["stats"]["dps"]) + "\n" +
									"Size: " + str(Global.blueprints[blueprint]["stats"]["length"]) + "m")
			
		"basic_gun": # {"type": "basic_gun", "damage": 10, "shoot_speed": 10, "shots_per_click": 1, "spacing": 0.5}
			$Sprite2/Stats.text += ("Damage: " + str(Global.blueprints[blueprint]["stats"]["damage"]) + "/hit\n" + 
									"Speed: " + str(Global.blueprints[blueprint]["stats"]["shoot_speed"]) + " shot(s)/sec\n" +
									"DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]/Global.blueprints[blueprint]["stats"]["shoot_speed"], 0.1)))
			
		"laser_gun": # {"type": "laser_gun", "dps": 35}
			$Sprite2/Stats.text += "\nDPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])
			
		"upgrade": # {"type": "upgrade", "effect": 100, "max": 5}
			$Sprite2/Stats.text = ("\nEffect: +" + str(Global.blueprints[blueprint]["stats"]["effect"]) + " " + blueprint + "\n" +
									"(Max " + str(Global.blueprints[blueprint]["stats"]["max"]) + " upgrades)")
		
		"flashlight":
			$Sprite2/Stats.text = "- TIP -\n insert something we learn from playtesting here"
		
		"night_vision":
			$Sprite2/Stats.text += "- TIP -\n insert something we learn from playtesting here"
			
		"scrapper":
			$Sprite2/Stats.text += "- TIP -\n It's a large investment, but delayed rewards are always sweeter!"
			
		"jump":
			$Sprite2/Stats.text += "- TIP -\n Can help you reach higher places"
		
		"dash":
			$Sprite2/Stats.text += "- TIP -\n Can help you reach further places"
	
func _process(delta):
	modulate = Color(1.0, 1.0, 1.0, 1-get_global_position().distance_to(mid.get_global_position())/256)
	
	
	if Global.selected == index and not prev_select:
		anim.play("info")
		if Global.blueprints[blueprint]["stats"]["type"] == "upgrade":
			Global.can_enter = not played and not (Global.upgrades[blueprint] - Global.blueprints[blueprint]["stats"]["baseval"])/Global.blueprints[blueprint]["stats"]["effect"] == Global.blueprints[blueprint]["stats"]["max"]
		else:
			Global.can_enter = not played
		
	if not Global.selected == index and prev_select:
		anim.play_backwards("info")
#		if played:
#			played = false
#			anim.play_backwards("info")
	
	prev_select = Global.selected == index
	if Global.entered:
		if prev_select:
			Global.entered = false
			anim.play("zoom")
			for mat in Global.COST_KEY:
				Global.items[mat]["bunker"] -= Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(mat)]
			Global.transition()
			Global.player.arm_anim.play("arm_down")
			yield(get_tree().create_timer(1.0), "timeout")
			Global.player.in_menu = false
			Global.blueprint_up = false
			Global.selected = -1
			if Global.blueprints[blueprint]["stats"]["type"] == "upgrade":
				Global.upgrades[blueprint] += Global.blueprints[blueprint]["stats"]["effect"]
				Global.outfitting_menu.update_ui()
			# add code to add created thing
			yield(get_tree().create_timer(1.0), "timeout")
			Global.player.can_move = true
			Global.transition()
		else:
			pass

#func _input(event):
#	if event.is_action_pressed("drop") and Global.selected == index:
#		if played:
#			played = false
#			anim.play_backwards("info") 
#		else: 
#			played = true
#			anim.play("info") 
