extends Entity2D

export (int) var speed = 600
export (int) var jump_speed = -1700
export (int) var gravity = 3000
export (int) var friction = 0.1
export (int) var acceleration = 0.5

export (int) var weight_capacity = 20 

var velocity =  Vector2.ZERO
var can_move = true
var can_jump = false
var can_dash = false
var facing_left: bool

func _ready():
	Global.player = self

func get_input():
	velocity.x = 0
	var dir = 0
	
	if Input.is_action_pressed("right") and can_move:
		facing_left = false
		velocity.x += speed
		dir += 1
	
	if Input.is_action_pressed("left") and can_move:
		facing_left = true
		velocity.x -= speed
		dir -= 1
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		
	elif dir == 0:
		velocity.x = lerp (velocity.x, 0, friction)
	
	
	
	#@ greg here \/
	match Global.player_parts["primary_arm"]:
		# Global.blueprints[blueprint]["stats"][<value>] to make your guns work with every one of that type, next to each case is a list of all the values you have avalable 
		"basic_gun": #{"type": "basic_gun", "damage": 5, "shoot_speed": 1.0, "shots_per_click": 4, "spacing": 0.1} (spacing is time between each bullet in a click)
			if Input.is_action_just_pressed("reload"):
				$Weapon.reload()
#			if $Weapon.automatic: no weapons are auto
#				if Input.is_action_pressed("shoot"):
#					$Weapon.fire()
#			else:
			if Input.is_action_just_pressed("shoot"):
				$Weapon.fire()
			$AimPosition.position = (get_local_mouse_position()).normalized() * 64
			$Weapon.shoot_dir = get_global_mouse_position() - global_position
			
		"basic_melee": # {"stats": {"type": "basic_melee", "damage": 10, "swing_speed": 0.4, "length": 0.75}
			pass
		"close_melee": # {"type": "close_melee", "dps": 60, "length": 0.5} (think chainsaw, constant dps at a short tange)
			pass
		"laser_gun": # {"type": "laser_gun", "dps": 40} (inf range deathbeam does constant dps)
			pass
			
func _physics_process(delta: float) -> void:
	
	get_input()
	velocity.y += gravity * delta
	velocity = move(velocity, delta)
	velocity.x = lerp(velocity.x, 0, 0.2)


func _input(event):
	if event.is_action_pressed("collect") and can_move:
		for b in $Area2D.get_overlapping_areas():
			b = b.get_node("../")
			if b.is_in_group("BunkerEntrance"):
				for blueprint in range(Global.items["blueprint"]["stored"]):
					Global.change_item_count("blueprint", -1)
					Global.blueprints[Global.items["blueprint"]["type"][blueprint]]["has_blueprint"] = true
					print("added blueprint ", Global.items["blueprint"]["type"][blueprint])
				can_move = false
				Global.transition()
				Global.root.save_scene()
				yield(get_tree().create_timer(1.0), "timeout")
				get_tree().change_scene("res://Scenes/Bunker.tscn")
				
			elif b.is_in_group("Item") and Global.change_item_count(b.item_name, 1):
				if b.item_name == "blueprint":
					Global.items["blueprint"]["type"].append(b.blueprint)
				b.queue_free()
				break
	
	if event.is_action_pressed("jump") and can_move and can_jump:
		if is_on_floor():
			velocity.y = jump_speed


