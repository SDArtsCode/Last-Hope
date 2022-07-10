extends RigidBody2D

class_name Item2D

export var item_name = ""
export (bool) var collected = false

func _ready() -> void:
	$Label.hide()

func _on_Area2D_body_entered(body: Node) -> void:
	$Label.show()


func _on_Area2D_body_exited(body: Node) -> void:
	$Label.hide()

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("collect"):
		var bodies = $Area2D.get_overlapping_bodies()
		for b in bodies:
			if b.name == "Player" and Global.change_item_count(item_name, 1):
				self.queue_free()
	
