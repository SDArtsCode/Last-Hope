extends Entity2D

export (float) var speed = 100
export (float) var jump_force = 100
export (float) var aggro_range = 10

var idleTimer = 2.0
var walkTimer = 5.0

var velocity = Vector2.ZERO

enum States {
	IDLE
	WALK,
	JUMP
}

var state = States.IDLE

func _ready():
	pass
	
func _physics_process(delta):
	
	match(state):
		States.IDLE:
			idling()
		States.WALK:
			walking()
		States.JUMP:
			for p in $Area2D.get_overlapping_bodies():
				if p.is_in_group("Platform"):
					pass
			jumping(Vector2.ZERO)
			
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

func idling():
	pass

func walking():
	pass

func jumping(var force):
	#pick platform or 
	pass
