extends Entity2D

export (int) var speed = 600
export (int) var jump_speed = -1700
export (int) var gravity = 3000
export (int) var friction = 0.1
export (int) var acceleration = 0.5

export (int) var weight_capacity = 20 

var velocity =  Vector2.ZERO
var can_move = true
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
	
	# weapon shid
	if Input.is_action_just_pressed("reload"):
		$Weapon.reload()
	if $Weapon.automatic:
		if Input.is_action_pressed("shoot"):
			$Weapon.fire()
	else:
		if Input.is_action_just_pressed("shoot"):
			$Weapon.fire()
	$AimPosition.position = (get_local_mouse_position()).normalized() * 64
	$Weapon.shoot_dir = get_global_mouse_position() - global_position
	
func _physics_process(delta: float) -> void:
	
	get_input()
	velocity.y += gravity * delta
	velocity = move(velocity, delta)
	velocity.x = lerp(velocity.x, 0, 0.2)
	
	if Input.is_action_just_pressed("jump") and can_move:
		if is_on_floor():
			velocity.y = jump_speed
	
		

