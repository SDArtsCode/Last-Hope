extends StaticBody2D

var delay = 0.5
var enable = true

func DisableCollider():
	$CollisionShape2D.disabled = true;
	enable = false
	delay = 0.5

func _process(delta):
	if !enable:
		delay -= delta
	if(delay <= 0):
		$CollisionShape2D.disabled = false;
