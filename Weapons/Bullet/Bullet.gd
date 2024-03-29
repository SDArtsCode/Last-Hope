extends KinematicBody2D

var direction = Vector2()
var speed := 1
var damage := 20
var initial_position = position

func _ready():
	z_index = 10
	
func _physics_process(delta):
	rotation = atan2(direction.y, direction.x) + PI/2
	if speed > 1000:
		var _movement = move_and_slide(direction * speed * delta, Vector2.UP, false, 4, PI/4, false)
	if get_slide_count() > 0:
		var collision = get_slide_collision(0)
		if collision.collider.is_in_group("entity"):
			collision.collider.damage(damage)
		for body in range(get_slide_count()):
			if get_slide_collision(body).get_collider().name != "Bullet":
				queue_free()
	if (global_position - initial_position).length() > 2000:
		queue_free()
	
