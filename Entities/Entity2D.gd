extends KinematicBody2D

class_name Entity2D

export var health_bar_path : NodePath
var health_bar = null

export var MAX_HEALTH : int = 10.0
export var knockback_resistance : float = 1.0

var health : int = MAX_HEALTH
var impulse_vector : Vector2 = Vector2()
var impulse_strength : float = 0.0
var vel : Vector2 = Vector2()

var timer = 0.0
var disabled : bool = false

signal OnEntityDead()

func _ready():
	add_to_group('entity')
	if is_instance_valid(get_node(health_bar_path)):
		health_bar = get_node(health_bar_path)
	health = MAX_HEALTH

func _physics_process(delta):
	impulse_vector.x = lerp(impulse_vector.x, 0, 5.0 * delta)
	impulse_vector.y = 0.0
	if impulse_vector.length() < 0.2:
		impulse_vector = Vector2()
		impulse_strength = 0.0
		
func move(move_vel : Vector2, delta : float):
	vel = -impulse_vector + move_vel
	vel = move_and_slide(vel, Vector2.UP, false, 4, PI/4, false)
	return vel
	
func damage(dmg : int, impulse_dir : Vector2 = Vector2(), strength : float = 0):
	set_health(health - dmg)
	impulse(impulse_dir.normalized(), strength)
	#(self.name + " health: " + str(health) + " / " + str(MAX_HEALTH))

func set_health(new_health : int):
	if new_health <= 0 and health > 0:
		kys()
	health = new_health
	if health_bar:
		health_bar.updateHealth(health)
	
func kys():
	emit_signal("OnEntityDead")
	# queue_free()
	
func impulse(dir : Vector2, strength: float):
	impulse_strength = strength
	impulse_vector = dir * strength / knockback_resistance
