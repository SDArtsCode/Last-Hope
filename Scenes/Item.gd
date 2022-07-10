extends Node2D

export (int) var weight = 0
export var item_name = ""
export (bool) var collected = false


func _ready() -> void:
	$Item/Label.hide()

func _on_Area2D_body_entered(body: Node) -> void:
	$Item/Label.show()


func _on_Area2D_body_exited(body: Node) -> void:
	$Item/Label.hide()

func _physics_process(delta: float) -> void:
	
	if Input.is_action_just_pressed("collect"):
		Global.item_collected = true
		var bodies = $Area2D.get_overlapping_bodies()
		for b in bodies:
			if b.name == "Player":
				self.queue_free()
				Global.item_name = item_name
				Global.item_weight = weight
	
