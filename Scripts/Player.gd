extends Entity2D

export (int) var speed = 200
export (int) var dash_speed = 200
export (int) var jump_speed = -1700
export (int) var gravity = 3000
export (float) var friction = 0.3
export (float) var acceleration = 0.4
export (int) var weight_capacity = 20 

var shoot_timer = 0.0
var current_weapon = 0

#double jump
var has_double_jump = false
var jump_counter = 0

#dash
var has_dash = false
var can_dash = false
var is_dashing = false
var dash_timer = 0.3
var dash_recharge = 2.0
var lastDir = 0

var velocity =  Vector2.ZERO
var can_move = true
var can_jump = true


func _ready():
#	if get_node("../../Camera2D") != null:
#		$RemoteTransform2D.remote_path = NodePath("../../Camera2D")
#
#	else:
#		print("Cannot find camera")
	
	Global.player = self
	for m in Global.upgrades["movement"]:
		if m == "dash":
			has_dash = true
		if m == "double_jump":
			has_double_jump = true

func get_input():
	#input
	var dir = 0
	if Input.is_action_pressed("right") and can_move:
		dir = 1
	if Input.is_action_pressed("left") and can_move:
		dir = -1
	
	#movement  
	if(!is_dashing):
		if dir != 0:
			velocity.x = lerp(velocity.x, dir * speed , acceleration)
		elif dir == 0:
			velocity.x = lerp(velocity.x, 0, friction)
	
	#dashing
	if(has_dash):
		if Input.is_action_pressed("dash") and can_dash and can_move and dir != 0:
			can_dash = false
			is_dashing = true
			lastDir = dir
		
	
	#weapon shooting
	match Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["type"]:
		"basic_gun": #{"type": "basic_gun", "damage": 5, "shoot_speed": 1.0, "shots_per_click": 4, "spacing": 0.1} (spacing is time between each bullet in a click)
			if Input.is_action_just_pressed("reload"):
				$Weapon.reload()
				
			if Input.is_action_just_pressed("shoot") and timer >= Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["shoot_speed"]:
				timer = 0.0
				
#					if Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["spacing"] < 0.05:
				if Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["spacing"] >= 0.1:
					$Weapon.bullet_per_shot = 1
					for i in range(Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["shots_per_click"]):
						$Weapon.fire()
						yield(get_tree().create_timer(Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["spacing"]), "timeout")
				
				else:
					$Weapon.bullet_per_shot = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["shots_per_click"]
					$Weapon.fire()
			
			$AimPosition.position = (get_local_mouse_position()).normalized() * 69
			$Weapon.accuracy = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["accuracy"]
			$Weapon.damage = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["damage"]
			$Weapon.shoot_dir = get_global_mouse_position() - global_position
			
		"basic_melee": # {"stats": {"type": "basic_melee", "damage": 10, "swing_speed": 0.4, "length": 0.75}
			$Melee.melee_damage = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["damage"]
			$Melee.melee_distance = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["length"] * 100
			$Melee.melee_speed = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["swing_speed"]
			$Melee.melee_dir = get_global_mouse_position() - global_position
			if Input.is_action_just_pressed("shoot"):
				$Melee.attack()
		"close_melee": # {"type": "close_melee", "dps": 60, "length": 0.5} (think chainsaw, constant dps at a short tange)
			$Laser.laser_dir = get_global_mouse_position() - global_position
			$Laser.laser_distance = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["length"]*100
			$Laser.laser_damage = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["dps"]/5
			if Input.is_action_just_pressed('shoot') or Input.is_action_just_released('shoot'):
				$Laser.toggle_active()
		"laser_gun": # {"type": "laser_gun", "dps": 40} (inf range deathbeam does constant dps)
			$Laser.laser_dir = get_global_mouse_position() - global_position
			$Laser.laser_distance = 2000
			$Laser.laser_damage = Global.blueprints[Global.upgrades["weapons"][current_weapon]]["stats"]["dps"]/5
			if Input.is_action_just_pressed('shoot') or Input.is_action_just_released('shoot'):
				$Laser.toggle_active()
		
func _physics_process(delta: float) -> void:
	
	if Global.camera != null:
		Global.camera.position = position 
	
	timer += delta
	get_input()
	
	if(is_dashing):
		velocity.y = 0
		velocity.x = lastDir * dash_speed
		dash_timer -= delta
		if(dash_timer <= 0):
			dash_timer = 0.3
			is_dashing = false
	else:
		velocity.y += gravity * delta
		
	if(!is_dashing and !can_dash):
		dash_recharge -= delta
		if(dash_recharge <= 0):
			dash_recharge = 2.0
			can_dash = true
	
	if is_on_floor():
		can_jump = true
	
	velocity = move(velocity, delta)

	if is_on_floor():
		if velocity.length() < 10:
			if $AnimatedSprite.animation == "Running":
				$AnimatedSprite.stop()
			$AnimatedSprite.play("Idle")
		else:
			if $AnimatedSprite.animation == "Idle":
				$AnimatedSprite.stop()
			$AnimatedSprite.play("Running")
	else:
		pass
	
	if sign(velocity.x) < 0:
		$AnimatedSprite.scale.x = 1
	elif sign(velocity.x) > 0:
		$AnimatedSprite.scale.x = -1
		
func _input(event):

	#jumping
	if(!has_double_jump):
		if event.is_action_pressed("jump") and can_move and can_jump:
			if is_on_floor():
				velocity.y = jump_speed
	else:
		if event.is_action_pressed("jump") and can_move and can_jump:
			jump_counter += 1
			velocity.y = jump_speed
			if(jump_counter >= 2):
				can_jump = false
			
	#platforming
	if (event.is_action_pressed("down") and is_on_floor()):
		for b in $Area2D.get_overlapping_bodies():
			if b.is_in_group("Platform"):
				b.DisableCollider()
		pass

	#weapon switching
	for i in range(1, 10):
		if event.is_action_pressed(str(i)):
			current_weapon = i - 1
			pass
		pass
	
	#interactions (fix)
	if event.is_action_pressed("interact") and can_move:
		for b in $Area2D.get_overlapping_areas():
			b = b.get_node("../")
			if b.is_in_group("BunkerEntrance"):
				for blueprint in range(Global.items["blueprint"]["stored"]):
					Global.change_item_count("blueprint", -1)
					Global.blueprints[Global.items["blueprint"]["type"][blueprint]]["has_blueprint"] = true
					print("added blueprint ", Global.items["blueprint"]["type"][blueprint])
					
				for item in Global.items.keys():
					if item != "blueprint":
						Global.items[item]["bunker"] += Global.items[item]["stored"]
						print("bunkered ", Global.items[item]["stored"], " ", item)
						Global.items[item]["stored"] = 0
				
				can_move = false
				Global.inventory_controller.update_inventory()
				Global.transition()
				Global.root.save_scene()
				yield(get_tree().create_timer(1.0), "timeout")
				get_tree().change_scene("res://Scenes/Bunker.tscn")
				
			elif b.is_in_group("Item") and Global.change_item_count(b.item_name, 1):
				if b.item_name == "blueprint":
					Global.items["blueprint"]["type"].append(b.blueprint)
				b.queue_free()
				break
	




