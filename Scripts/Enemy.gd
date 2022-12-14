extends Entity2D

export (float) var speed = 25
export (float) var jump_force = 100
export (float) var aggro_range = 10

export(float) var jump_time = 2.0
export(float) var jump_height = 1.5
export(float) var jump_velocity_x = 75

var direction = 1

var idleTimer = 2.0
var walkTimer = 5.0
var minJumpTimer = 0.5
var is_jumped = false
var velocity = Vector2.ZERO

enum States {
	IDLE
	WALK,
	TOWARDS_PLAYER,
	JUMP
}

var state = States.IDLE

func _ready():
	state = States.IDLE
	$RayHolder/RayCast2D.scale.x = direction
	pass
	
func _physics_process(delta):
	match(state):
		States.IDLE:
			idling(delta)
		States.WALK:
			walking(delta)
		States.TOWARDS_PLAYER:
			towards_player(delta)
		States.JUMP:
			jumping(delta)
	
	if !is_on_floor():
		velocity.y += 400 * delta
	
	move(velocity, delta)
	
	if is_on_floor():
		if abs(velocity.x) < 5:
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
	

func idling(delta):
	#detect_player()
	velocity.x = 0

func walking(delta):
	#detect_player()
	if($RayHolder/RayCast2D.get_collider() != null and ($RayHolder/RayCast2D.get_collider().is_in_group("Ground") or $RayHolder/RayCast2D.get_collider().is_in_group("Platform"))):
		pass
	else:
		direction *= -1
		$RayHolder.scale.x *= -1
	velocity.x = direction * speed
	
	
func towards_player(delta):
	attack_player()
	
	direction = (global_position.x - Global.player.global_transform.x) / abs(global_position.x - Global.player.global_transform.x)
	velocity.x = direction * speed
	
	if(!detect_player()):
		state = States.IDLE
		
func jumping(delta):
	minJumpTimer -= delta
	if(minJumpTimer < 0):
		if is_on_floor():
			velocity.x = 0
			minJumpTimer = 0.5
			state = States.WALK
	pass

func start_jump():
	var jump_velocity = Vector2.ZERO
	for p in $Area2D.get_overlapping_bodies():
		if p.is_in_group("Platform") and p != $RayHolder/RayCast2D.get_collider():
			var time = (p.global_position.x - $Position2D.global_position.x)/jump_velocity_x
			jump_velocity.x = jump_velocity_x
			jump_velocity.y = ((p.global_position.y - $Position2D.global_position.y) - (0.5 * 400 * pow(time, 2)))/time
			velocity = jump_velocity * clamp (p.global_position.x - global_position.x, -1, 1)
			is_jumped = false
			state = States.JUMP
			return
	state = States.IDLE
	$Timer.start(idleTimer)

func detect_player():
	if(Global.player.global_position - global_position > aggro_range):
		state = States.TOWARDS_PLAYER
		return true
	return false
	
func attack_player():
	pass

func _on_Timer_timeout():
	match(state):
		States.IDLE:
			$Timer.start(walkTimer)
			state = States.WALK
		States.WALK:
			$Timer.start(idleTimer)
			start_jump()
			
		
