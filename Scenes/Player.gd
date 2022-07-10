extends KinematicBody2D

export (int) var speed = 400
export (int) var jump_speed = -1600
export (int) var gravity = 5200
export (int) var friction = 0.1
export (int) var acceleration = 0.5

export (int) var weight_capacity = 20 

var velocity =  Vector2.ZERO

	
func get_input():
	velocity.x = 0
	var dir = 0
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed
		dir += 1
	
	if Input.is_action_pressed("ui_left"):
		velocity.x -= speed
		dir -= 1
	
	if dir != 0:
		velocity.x = lerp(velocity.x, dir * speed, acceleration)
		
	elif dir == 0:
		velocity.x = lerp (velocity.x, 0, friction)
		
func _physics_process(delta: float) -> void:
	
	get_input()
	velocity.y += gravity * delta
	velocity = move_and_slide(velocity, Vector2.UP)	
	velocity.x = lerp(velocity.x, 0, 0.2)
	
	if Input.is_action_just_pressed("ui_up"):
		if is_on_floor():
			velocity.y = jump_speed
			
			
	

