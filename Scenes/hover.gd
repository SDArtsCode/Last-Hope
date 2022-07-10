extends AnimationPlayer


func _ready():
	yield(get_tree().create_timer(randf()), "timeout")
	play("hover")
