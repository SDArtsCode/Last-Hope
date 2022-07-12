extends RigidBody2D

class_name Item2D

export var item_name = ""
export var blueprint = ""
export (bool) var collected = false

func _ready() -> void:
	$Label.hide()

func _on_Area2D_body_entered(body: Node) -> void:
	if body.is_in_group("Player"):
		$Label.show()


func _on_Area2D_body_exited(body: Node) -> void:
	if body.is_in_group("Player"):
		$Label.hide()

