extends Node2D

var blueprint: String = "pistol"
var index = 0
var prev_select: bool = false
var played: bool = false

onready var mid = get_node("../../bg")
onready var anim = $AnimationPlayer

func _ready():
	$Sprite2/Title.text = Global.blueprints[blueprint]["name"]
	$Sprite2/Discription.text = Global.blueprints[blueprint]["discription"]
	var type = Global.blueprints[blueprint]["stats"]["type"]
	
	$Sprite2/Cost.modulate = Color(0.0, 1.0, 0.0)
	for mat in Global.items.keys():
		if Global.items[mat]["stored"] >= Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(mat)]:
			$Sprite2/Cost.modulate = Color(1.0, 0.0, 0.0)
	
	if $Sprite2/Cost.modulate == Color(1.0, 0.0, 0.0):
		for key in Global.COST_KEY:
			if Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)] != 0:
				$Sprite2/Cost.text += Global.items[key]["name"] + ": " + str(Global.blueprints[blueprint]["cost"][Global.COST_KEY.find(key)]) + " (" + str(Global.items[key]["stored"]) + ")\n"
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
									"DPS: " + str(stepify(Global.blueprints[blueprint]["stats"]["damage"]*Global.blueprints[blueprint]["stats"]["shoot_speed"], 0.1)))
			
		"laser_gun": # {"type": "laser_gun", "dps": 35}
			$Sprite2/Stats.text += "\nDPS: " + str(Global.blueprints[blueprint]["stats"]["dps"])
			
		"upgrade": # {"type": "upgrade", "effect": 100, "max": 5}
			$Sprite2/Stats.text = ("\nEffect: +" + str(Global.blueprints[blueprint]["stats"]["effect"]) + " " + blueprint + "\n" +
									"(Max " + str(Global.blueprints[blueprint]["stats"]["max"]) + " upgrades)")
		
		"flashlight":
			$Sprite2/Stats.text = "- TIP -\n insert something we learn from playtesting here"
		
		"night_vision":
			$Sprite2/Stats.text += "- TIP -\n insert something we learn from playtesting here"
			
		"scraper":
			$Sprite2/Stats.text += "- TIP -\n It's a large investment, but delayed rewards are always sweeter!"
			
		"jump":
			$Sprite2/Stats.text += "- TIP -\n Can help you reach higher places"
		
		"dash":
			$Sprite2/Stats.text += "- TIP -\n Can help you reach further places"
	
func _process(delta):
	modulate = Color(1.0, 1.0, 1.0, 1-get_global_position().distance_to(mid.get_global_position())/256)
	
	
	if Global.selected == index and not prev_select:
		anim.play("info")
		
	if not Global.selected == index and prev_select:
		anim.play_backwards("info")
#		if played:
#			played = false
#			anim.play_backwards("info")
	
	prev_select = Global.selected == index
	
#func _input(event):
#	if event.is_action_pressed("drop") and Global.selected == index:
#		if played:
#			played = false
#			anim.play_backwards("info") 
#		else: 
#			played = true
#			anim.play("info") 
